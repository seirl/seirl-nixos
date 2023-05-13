{ config, pkgs, ... }:

{
  home.username = "seirl";
  home.homeDirectory = "/home/seirl";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  imports = [
    ./git.nix
    ./graphical.nix
    ./i3.nix
    ./laptop.nix
    ./mercurial.nix
    ./ssh.nix
    ./tmux.nix
    ./urxvt.nix
    ./xcompose.nix
    ./zsh.nix
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
