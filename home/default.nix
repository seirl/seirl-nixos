{ config, pkgs, ... }:

{
  home.username = "seirl";
  home.homeDirectory = "/home/seirl";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  imports = [
    ./git.nix
    ./i3.nix
    ./mercurial.nix
    ./ssh.nix
    ./tmux.nix
    ./urxvt.nix
    ./zsh.nix
  ];

  home.file.".XCompose".source = ./source/xcompose.conf;
}
