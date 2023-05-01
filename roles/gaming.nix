{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.gaming;
in
{
  options = {
    my.roles.gaming.enable = lib.mkEnableOption "Gaming computer";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (wineWowPackages.full.override {
        wineRelease = "staging";
        mingwSupport = true;
      })
      winetricks
    ];

    hardware.opengl.driSupport32Bit = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
