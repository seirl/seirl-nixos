{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.monitoring;
  grafanaFileProviderSecret = secretName: "$__file{${config.sops.secrets."${secretName}".path}}";
in
{
  options = {
    my.roles.monitoring = {
      enable = lib.mkEnableOption "Enable monitoring";
      vhost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "monitoring.example.com";
        description = "Hostname of the nginx vhost.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."grafana/secret_key" = {
      owner = "grafana";
      group = "grafana";
    };
    sops.secrets."grafana/admin_password" = {
      owner = "grafana";
      group = "grafana";
    };

    services.prometheus = {
      enable = true;
      port = 9001;
      scrapeConfigs = [
        {
          job_name = "hyjal";
          static_configs = [{
            targets = [ "hyjal.koin.fr:9002" ];
          }];
        }
      ];
    };

    services.grafana = {
      enable = true;
      settings = {
        server = {
          domain = cfg.vhost;
          root_url = "https://${cfg.vhost}/";
          http_port = 3541;
        };
        security = {
          admin_password = grafanaFileProviderSecret "grafana/admin_password";
          secret_key = grafanaFileProviderSecret "grafana/secret_key";
        };
        database.wal = true;
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [{
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }];
      };
    };

    services.nginx.virtualHosts."${cfg.vhost}" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      };
    };
  };
}
