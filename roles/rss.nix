{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.rss;
in
{
  options = {
    my.roles.rss.enable = lib.mkEnableOption "RSS client";
    my.roles.rss.vhost = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "rss.example.com";
      description = "Hostname of the nginx vhost.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tt-rss = {
      enable = true;
      selfUrlPath = "http://${cfg.vhost}";
      singleUserMode = true;
      virtualHost = cfg.vhost;
    };

    services.nginx.virtualHosts."${cfg.vhost}" = {
      # forceSSL = true;
      # enableACME = true;
    };
  };
}
