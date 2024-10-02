{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.smartd;
in
{
  options = {
    my.roles.smartd.enable = lib.mkEnableOption "Enable smartd notifications";
  };

  config = lib.mkIf cfg.enable {
    services.postfix.enable = true;
    services.postfix.setSendmail = true;
    services.smartd = {
      enable = true;
      notifications.x11.enable = true;
      notifications.mail.enable = true;
      notifications.mail.recipient = "antoine.pietri1+smartd@gmail.com";
      notifications.systembus-notify.enable = true;
    };
  };
}
