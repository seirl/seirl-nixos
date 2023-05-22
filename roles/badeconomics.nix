{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.badeconomics;
in {
  options = {
    my.roles.badeconomics.enable = lib.mkEnableOption "BadEconomics bots.";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."reddit-econ/ri-notify-bot" = {};

    systemd.services.badeconomics-ri-notify-bot = {
      serviceConfig = {
        User = "badeconomics-ri-notify-bot";
        DynamicUser = true;
        LoadCredential =
          "creds:${config.sops.secrets."reddit-econ/ri-notify-bot".path}";
        ExecStart =
          "${pkgs.badeconomics-ri-notify-bot}/bin/badeconomics-ri-notify-bot "
          + "-c \${CREDENTIALS_DIRECTORY}/creds";
      };
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
    };
  };
}
