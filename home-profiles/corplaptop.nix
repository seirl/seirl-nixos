{ pkgs, ... }:

{
  home.username = "seirl";
  home.homeDirectory = "/home/seirl";
  home.stateVersion = "25.05";

  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;

  my.home.graphical.enable = true;
  my.home.laptop.enable = true;
  my.home.glinux.enable = true;
  services.autorandr.enable = false;
}
