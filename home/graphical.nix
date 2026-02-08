{ config, lib, pkgs, ... }:

let
  cfg = config.my.home.graphical;
in
{
  options = {
    my.home.graphical.enable = lib.mkEnableOption "Graphical machine";
  };

  config = lib.mkIf cfg.enable {
    my.home.i3.enable = true;
    my.home.gnome.enable = true;
    my.home.alacritty.enable = true;
    my.home.urxvt.enable = true;
    my.home.xcompose.enable = true;
    my.home.vscode.enable = true;
    my.home.rclone.enable = true;

    services.dunst.enable = true;

    services.autorandr.enable = lib.mkDefault true;

    home.sessionVariables = {
      TERMINAL = "alacritty";
    };
  };
}
