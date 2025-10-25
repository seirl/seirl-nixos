{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.crowdbar;
  crowdbarPort = 8071;
  pythonEnv = pkgs.python3.withPackages (p: [
    p.gunicorn
    pkgs.crowdbar
  ]);
in
{
  options = {
    my.roles.crowdbar = {
      enable = lib.mkEnableOption "Crowdbar website";
      vhost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "crowdbar.example.com";
        description = "Hostname of the nginx vhost.";
      };
      workers = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "Number of workers.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.crowdbar = {
      serviceConfig = {
        DynamicUser = true;
        ExecStart = lib.concatStringsSep " " [
          "${pythonEnv}/bin/gunicorn"
          "--workers ${toString cfg.workers}"
          "-b 127.0.0.1:${toString crowdbarPort}"
          "--worker-class aiohttp.GunicornWebWorker"
          "crowdbar.app:get_app"
        ];
      };
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
    };

    services.nginx.virtualHosts."${cfg.vhost}" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString crowdbarPort}";
      };
    };
  };
}
