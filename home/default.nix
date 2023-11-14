{ config, pkgs, ... }:

{
  home.username = "seirl";
  home.homeDirectory = "/home/seirl";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  imports = [
    ./alacritty.nix
    ./git.nix
    ./graphical.nix
    ./i3.nix
    ./kitty.nix
    ./laptop.nix
    ./mercurial.nix
    ./nvim
    ./ssh.nix
    ./tmux.nix
    ./urxvt
    ./vscode.nix
    ./wezterm.nix
    ./xcompose
    ./zsh.nix
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
