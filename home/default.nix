{ config, pkgs, ... }:

{
  home.username = "seirl";
  home.homeDirectory = "/home/seirl";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  imports = [
    ./git.nix
    ./mercurial.nix
    ./tmux.nix
    ./urxvt.nix
  ];

  home.file.".XCompose".source = ./xcompose.conf;
}
