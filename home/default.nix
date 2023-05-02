{ config, pkgs, ... }:

{
  imports = [
    ./urxvt.nix
    ./mercurial.nix
    ./git.nix
  ];

  home.username = "seirl";
  home.homeDirectory = "/home/seirl";
  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
