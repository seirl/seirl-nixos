{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.seedbox;
  transmissionRpcPort = 9091;
in
{
  options = {
    my.roles.seedbox.enable = lib.mkEnableOption "Seedbox";
    my.roles.seedbox.vhost = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "torrent.example.com";
      description = "Hostname of the nginx vhost.";
    };
    # Cannot override: https://github.com/NixOS/nixpkgs/issues/183429
    # my.roles.seedbox.downloadDir = lib.mkOption {
    #   type = lib.types.path;
    #   default = config.services.transmission.home + "/Downloads";
    #   example = "/srv/downloads";
    #   description = "Directory where the downloaded files will be stored";
    # };
  };

  config = lib.mkIf cfg.enable {
    services.transmission = {
      enable = true;
      package = pkgs.transmission_4;
      settings = {
        rpc-enabled = true;
        rpc-port = transmissionRpcPort;
        rpc-host-whitelist = "";
        rpc-host-whitelist-enabled = false;

        # Cannot override: https://github.com/NixOS/nixpkgs/issues/183429
        # download-dir = "${cfg.downloadDir}";
      };
    };

    # Transmission 3.0 leaks memory like crazy, restrict it to 2GB RAM and auto
    # restart.
    systemd.services.transmission.serviceConfig = {
      Restart = "always";
      RestartSec = 5;
      MemoryMax = "2G";
    };


    sops.secrets."seedbox/transmission-htpasswd" = {
      owner = config.users.users.nginx.name;
    };
    sops.secrets."seedbox/downloads-htpasswd" = {
      owner = config.users.users.nginx.name;
    };

    users.users.nginx.extraGroups = [ "transmission" "secrets" ];
    services.nginx.virtualHosts."${cfg.vhost}" = {
      forceSSL = true;
      enableACME = true;

      locations."/download" = {
        extraConfig = ''
          rewrite ^([^.]*[^/])$ $1/ permanent;  # Add trailing slash
        '';
      };

      locations."/download/" = {
        alias = "${config.services.transmission.settings.download-dir}/";
        basicAuthFile = config.sops.secrets."seedbox/downloads-htpasswd".path;
        extraConfig = ''
          autoindex on;
        '';
      };

      locations."/" = {
        basicAuthFile = config.sops.secrets."seedbox/transmission-htpasswd".path;
        proxyPass = "http://127.0.0.1:${toString transmissionRpcPort}";
      };
    };
  };
}
