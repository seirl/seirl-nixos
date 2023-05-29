{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.epiquote;
  epiquotePort = 8094;
in
{
  options = {
    my.roles.epiquote = {
      enable = lib.mkEnableOption "Epiquote website";
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
          static_root = "${pkgs.epiquote}/static";
        };
        epita_connect.enable = false;
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
          DynamicUser = true;
          LoadCredential =
            "creds.conf:${config.sops.secrets."epiquote/creds".path}";
          ExecStart = lib.concatStringsSep " " [
            "${pkgs.epiquote.dependencyEnv}/bin/gunicorn"
            "--workers ${toString cfg.workers}"
            "-b 127.0.0.1:${toString epiquotePort}"
            "epiquote.wsgi:application"
          ];
        };
        wantedBy = [ "multi-user.target" ];
        wants = [ "network.target" ];
      };
    };
}
