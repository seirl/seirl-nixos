{ config, pkgs, lib, ... }:

let
  cfg = config.my.home.gaming;
  winePkg = (pkgs.wineWowPackages.full.override {
    wineRelease = "staging";
    mingwSupport = true;
  });

  wowSharedPath = "${config.xdg.dataHome}/wineprograms/World of Warcraft";
  wowWinePrefix = "${config.xdg.dataHome}/wineprefixes/wow";
  wowPath = "${wowWinePrefix}/drive_c/Program Files (x86)/World of Warcraft";
  wowFlavor = "retail";
  wowAddonDir = "${wowPath}/_${wowFlavor}_/Interface/AddOns";
  wowBackupScript = "${config.home.homeDirectory}/wow-config/sync.sh";

  bnetSharedPath = "${config.xdg.dataHome}/wineprograms/Battle.net";
  bnetWinePrefix = "${config.xdg.dataHome}/wineprefixes/battlenet";
  bnetWowPath = "${bnetWinePrefix}/drive_c/Program Files (x86)/World of Warcraft";
  bnetPath = "${bnetWinePrefix}/drive_c/Program Files (x86)/Battle.net";
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
        Restart = "on-failure";
        RestartSec = 30;
      };
    };

    home.packages = [
      (pkgs.writeShellScriptBin "wow" ''
        set -e
        export WINEARCH=win64
        export WINEESYNC=1
        export WINEPREFIX="${wowWinePrefix}"
        mkdir -p $( dirname "${wowPath}" )
        ${pkgs.winetricks}/bin/winetricks dxvk
        ln -sfn "${wowSharedPath}" "${wowPath}"
        ${wowBackupScript}
        ${winePkg}/bin/wine64 "${wowPath}/_${wowFlavor}_/Wow.exe"
        ${wowBackupScript}
      '')

      (pkgs.writeShellScriptBin "battlenet" ''
        set -e
        export WINEARCH=win64
        export WINEESYNC=1
        export WINEPREFIX="${bnetWinePrefix}"
        mkdir -p $( dirname "${bnetPath}" )
        ${pkgs.winetricks}/bin/winetricks dxvk
        ln -sfn "${bnetSharedPath}" "${bnetPath}"
        ln -sfn "${wowSharedPath}" "${bnetWowPath}"
        ${winePkg}/bin/wine64 "${bnetPath}/Battle.net.exe"
      '')
    ];
  };
}
