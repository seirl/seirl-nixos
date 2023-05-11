{ config, lib, ... }:

let
  cfg = config.my.roles.nginx;
in
{
  options = {
    my.roles.nginx.enable = lib.mkEnableOption "Nginx Server";
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      statusPage = true; # For monitoring scraping.

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
