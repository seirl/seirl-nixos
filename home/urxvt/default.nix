{ config, lib, ... }:

let
  cfg = config.my.home.urxvt;
in
{
  options = {
    my.home.urxvt.enable = lib.mkEnableOption "Enable urxvt config";
  };

  config = lib.mkIf cfg.enable {
    programs.urxvt = {
      enable = true;
      scroll.bar.enable = false;
      iso14755 = false;

      fonts = [
        "xft:DejaVu Sans Mono:pixelsize=11:antialias=true"
        "xft:Symbola:pixelsize=11:antialias=false"
      ];

      keybindings = {
        "M-u" = "matcher:select";
        "C-equal" = "perl:font-size:increase";
        "Shift-Control-C" = "perl:clipboard:copy";
        "Control-Insert" = "perl:clipboard:copy";
      };

      extraConfig = {
        termName = "rxvt-256color";
        urgentOnBell = true;

        perl-lib = "~/.local/share/urxvt/ext";
        perl-ext-common = "default,matcher";
        perl-ext = "font-size";
        url-launcher = "xdg-open";
        "matcher.button" = "1";

        background = "[75]#000000";
        foreground = "white";
        depth = "32";
        tint = "black";
        color0 = "#2E3436";
        color1 = "#CC0000";
        color2 = "#4E9A06";
        color3 = "#C4A000";
        color4 = "#3465A4";
        color5 = "#75507B";
        color6 = "#06989A";
        color7 = "#D3D7CF";
        color8 = "#555753";
        color9 = "#EF2929";
        color10 = "#8AE234";
        color11 = "#FCE94F";
        color12 = "#729FCF";
        color13 = "#AD7FA8";
        color14 = "#34E2E2";
        color15 = "#EEEEEC";
      };
    };

    home.file."${config.xdg.dataHome}/urxvt/ext/font-size".source = ./ext/font-size;
  };
}
