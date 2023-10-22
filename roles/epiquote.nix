{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.epiquote;
  epiquotePort = 8094;
in
{
  options = {
    my.roles.epiquote = {
      enable = lib.mkEnableOption "Epiquote website";
      vhost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "epiquote.example.com";
        description = "Hostname of the nginx vhost.";
      };
      workers = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Number of workers.";
      };
    };
  };

  config =
    let
      epiquotePkg = pkgs.epiquote;
      epiquoteEnv = pkgs.python3.withPackages (ps: [
        epiquotePkg
        ps.gunicorn
        ps.ipython
      ]);
      epiquoteSettings = {
        epiquote = {
          prod = true;
          use_x_forwarded_port = true;
          static_root = "${epiquotePkg}/static";
          database_url = "postgresql:///epiquote";
          allowed_hosts = "${cfg.vhost}";
        };
        epita_connect = {
          enable = false;
        };
      };
      epiquoteSettingsPath = pkgs.writeText "settings.conf"
        (lib.generators.toINI { } epiquoteSettings);
      epiquoteManage = pkgs.writeShellScriptBin "epiquote-manage" ''
        export DJANGO_SETTINGS_MODULE=epiquote.settings
        export EPIQUOTE_SETTINGS_PATH=${epiquoteSettingsPath}
        export EPIQUOTE_CREDS_PATH=/run/credentials/epiquote.service/creds.conf
        exec ${epiquoteEnv}/bin/django-admin $*
      '';
    in
    lib.mkIf cfg.enable {
      sops.secrets."epiquote/creds" = { };

      systemd.services.epiquote = {
        environment = {
          DJANGO_SETTINGS_MODULE = "epiquote.settings";
          EPIQUOTE_SETTINGS_PATH = epiquoteSettingsPath;
          EPIQUOTE_CREDS_PATH = "%d/creds.conf";
        };
        serviceConfig = {
          User = "epiquote";
          LoadCredential =
            "creds.conf:${config.sops.secrets."epiquote/creds".path}";
          ExecStartPre =
            "${epiquoteEnv}/bin/django-admin migrate";
          ExecStart = lib.concatStringsSep " " [
            "${epiquoteEnv}/bin/gunicorn"
            "--workers ${toString cfg.workers}"
            "-b 127.0.0.1:${toString epiquotePort}"
            "epiquote.wsgi:application"
          ];
        };
        wantedBy = [ "multi-user.target" ];
        wants = [ "network.target" ];
        after = [ "postgresql.service" ];
        requires = [ "postgresql.service" ];
      };

      services.postfix.enable = true;

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "epiquote" ];
        ensureUsers = [
          {
            name = "epiquote";
            ensurePermissions = {
              "DATABASE epiquote" = "ALL PRIVILEGES";
            };
          }
        ];
      };

      users.users.nginx.extraGroups = [ "secrets" ];
      services.nginx.virtualHosts."${cfg.vhost}" = {
        forceSSL = true;
        enableACME = true;

        locations."/static/" = {
          alias = "${epiquotePkg}/static/";
        };

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString epiquotePort}";
        };
      };

      users.users.epiquote = {
        description = "Epiquote user";
        isSystemUser = true;
        group = "epiquote";
        useDefaultShell = true;
        packages = [ epiquoteManage ];
      };

      users.groups.epiquote = { };
    };
}
