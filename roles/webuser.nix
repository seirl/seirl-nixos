{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.webuser;
  baseDir = "/var/lib/webuser/";
in
{
  options = {
    my.roles.webuser = {
      enable = lib.mkEnableOption "Seedbox";
      vhost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "myuser.example.com";
        description = "Hostname of the nginx vhost.";
      };
      user = lib.mkOption {
        type = with lib.types; attrsOf anything;
        example = "config.users.users.seirl";
        description = "User that will get the webuser dir.";
      };
    };
  };

  config = {
    system.activationScripts.webuser = ''
      install -d -m 750 '${baseDir}'
      chown -R '${cfg.user.name}:webuser' ${baseDir}
    '';

    services.nginx.virtualHosts."${cfg.vhost}" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/lib/webuser";
      locations."/pub" = {
        extraConfig = ''
          autoindex on;
        '';
      };
    };

    users.users.nginx.extraGroups = [ "webuser" ];
    users.groups.webuser = { };
  };
}
