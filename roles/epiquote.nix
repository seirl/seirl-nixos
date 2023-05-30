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
      epiquoteSettings = {
        epiquote = {
          prod = true;
          use_x_forwarded_port = true;
          static_root = "${pkgs.epiquote}/static";
          database_url = "postgresql:///epiquote";
          allowed_hosts = "${cfg.vhost}";
        };
        epita_connect = {
          enable = false;
        };
      };
      epiquoteSettingsPath = pkgs.writeText "settings.conf"
        (lib.generators.toINI { } epiquoteSettings);
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
            "${pkgs.epiquote.dependencyEnv}/bin/django-admin migrate";
          ExecStart = lib.concatStringsSep " " [
            "${pkgs.epiquote.dependencyEnv}/bin/gunicorn"
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
          alias = "${pkgs.epiquote}/static/";
        };

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString epiquotePort}";
        };
      };

      users.users.epiquote = {
        description = "Epiquote user";
        isSystemUser = true;
        group = "epiquote";
      };

      users.groups.epiquote = { };
    };
}
