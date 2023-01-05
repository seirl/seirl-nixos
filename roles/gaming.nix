{ config, lib, pkgs, ... }:

{
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
}
