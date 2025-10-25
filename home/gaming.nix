{ config, pkgs, lib, ... }:

let
  cfg = config.my.home.gaming;
  winePkg = pkgs.wineWowPackages.staging;

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

  wowWineWrapper = (pkgs.writeShellScriptBin "wow-wine-wrapper" ''
    set -e
    export WINEARCH=win64
    export WINEESYNC=1
    export WINEPREFIX="${wowWinePrefix}"
    ${pkgs.winetricks}/bin/winetricks dxvk
    mkdir -p "${wowSharedPath}"
    mkdir -p "$( dirname "${wowPath}" )"
    ln -sfn "${wowSharedPath}" "${wowPath}"
    exec "$@"
  '');

  bnetWineWrapper = (pkgs.writeShellScriptBin "battlenet-wine-wrapper" ''
    set -e
    export WINEARCH=win64
    export WINEESYNC=1
    export WINEPREFIX="${bnetWinePrefix}"
    ${pkgs.winetricks}/bin/winetricks dxvk
    ${pkgs.winetricks}/bin/winetricks corefonts
    mkdir -p "${bnetSharedPath}"
    mkdir -p "${wowSharedPath}"
    mkdir -p "$( dirname "${bnetPath}" )"
    mkdir -p "$( dirname "${bnetWowPath}" )"
    ln -sfn "${bnetSharedPath}" "${bnetPath}"
    mkdir -p "${bnetWowPath}"
    mountpoint -q "${bnetWowPath}" ||
        ${pkgs.bindfs}/bin/bindfs --no-allow-other "${wowSharedPath}" "${bnetWowPath}"
    trap 'sleep 2 && fusermount -u "${bnetWowPath}"' EXIT INT TERM
    command "$@"
  '');

  wowStartScript = (pkgs.writeShellScriptBin "wow-start-script" ''
    ${wowBackupScript}
    trap '${wowBackupScript}' EXIT INT TERM
    ${winePkg}/bin/wine "${wowPath}/_${wowFlavor}_/Wow.exe"
  '');
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
        "${config.xdg.configHome}/instawow/plugins/instawow_tsm/credentials.json"
      );
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
          "${config.programs.instawow.package}/bin/instawow -v plugins tsm run"
        );
        Restart = "on-failure";
        RestartSec = 30;
      };
    };

    home.packages = [
      (pkgs.writeShellScriptBin "wow" ''
        ${wowWineWrapper}/bin/wow-wine-wrapper ${wowStartScript}/bin/wow-start-script
      '')

      (pkgs.writeShellScriptBin "battlenet" ''
        ${bnetWineWrapper}/bin/battlenet-wine-wrapper ${winePkg}/bin/wine "${bnetPath}/Battle.net.exe"
      '')

      (pkgs.writeShellScriptBin "battlenet-setup" ''
        bnet_setup=$( mktemp --tmpdir Battle.net-Setup.XXXXXXXXXX.exe )
        ${pkgs.wget}/bin/wget -O "$bnet_setup" 'https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
        ${bnetWineWrapper}/bin/battlenet-wine-wrapper ${winePkg}/bin/wine "$bnet_setup"
      '')

      (pkgs.writeShellScriptBin "satisfactory" ''
        ${lib.getExe pkgs.steam} steam://rungameid/526870
      '')
    ];
  };
}
