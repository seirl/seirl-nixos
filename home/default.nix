{ config, lib, pkgs, ... }:

{
  home.username = "seirl";
  home.homeDirectory = "/home/seirl";
  programs.home-manager.enable = true;

  imports = [
    ./alacritty.nix
    ./gaming.nix
    ./git.nix
    ./glinux
    ./gnome-terminal.nix
    ./gnome.nix
    ./graphical.nix
    ./i3.nix
    ./instawow.nix
    ./kitty.nix
    ./laptop.nix
    ./mercurial.nix
    ./nvim
    ./rclone.nix
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

  programs.bash.enable = true;

  sops = {
    defaultSopsFile = ../secrets/seirl.yaml;
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  };
  home.activation.restart-sops-nix = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if ${pkgs.systemd}/bin/systemctl --user list-unit-files | grep -q sops-nix.service; then
      ${pkgs.systemd}/bin/systemctl --user restart sops-nix
    fi
  '';
}
