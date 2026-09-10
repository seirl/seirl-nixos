{ pkgs, ... }:

{
  home.username = "seirl";
  home.homeDirectory = "/usr/local/google/home/seirl";
  home.stateVersion = "25.05";

  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;

  my.home.glinux.enable = true;
  programs.mercurial.enable = false;
}
