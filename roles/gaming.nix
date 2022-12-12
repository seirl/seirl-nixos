{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
    steam
    winetricks
  ];

  hardware.opengl.driSupport32Bit = true;
}
