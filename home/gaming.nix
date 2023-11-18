{ config, pkgs, lib, ... }:

let
  cfg = config.my.home.gaming;
  winePrefix = "${config.xdg.dataHome}/wineprefixes/wow";
  wowPath = "${winePrefix}/drive_c/Program Files (x86)/World of Warcraft";
  wowFlavor = "retail";
  wowAddonDir = "${wowPath}/_${wowFlavor}_/Interface/AddOns";
in
{
  options = {
    my.home.gaming.enable = lib.mkEnableOption "Gaming profile";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."instawow/access_tokens" = {
      path = "${config.xdg.configHome}/instawow/access_tokens.json";
    };
    sops.secrets."instawow/tsm_credentials" = {
      path = (
      "${config.xdg.stateHome}/instawow/profiles/__default__/plugins/"
      +"instawow_tsm/credentials.json");
    };
    programs.instawow = {
      enable = true;
      package = (pkgs.instawow.override {
        plugins = [
          pkgs.instawowPlugins.tsm
          pkgs.instawowPlugins.megazygor
        ];
      });
      profiles.__default__ = {
        gameFlavor = wowFlavor;
        addonDir = wowAddonDir;
      };
      credsPath = config.sops.secrets."instawow/access_tokens".path;
    };

    systemd.user.services.instawow-tsm = {
      Unit = {
        Description = "Instawow TSM updater service";
        After = [ "sops-nix.service" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = (
          "${config.programs.instawow.package}/bin/instawow -d tsm run"
        );
        RestartSec = 30;
      };
    };
  };
}
