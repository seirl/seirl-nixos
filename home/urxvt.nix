{ config, ... }:

{
  config.xresources.properties = {
    "urxvt*termName" = "rxvt-256color";

    "urxvt*background " = "[75]#000000";
    "urxvt*foreground " = "white";

    "*.font" = "xft:DejaVu Sans Mono:pixelsize=11:antialias=true,xft:Symbola:pixelsize=11:antialias=false";

    "urxvt*depth" = "32";
    "urxvt*tint " = "black";
    "urxvt*scrollBar " = "false";

    "urxvt*color0  " = "#2E3436";
    "urxvt*color1  " = "#CC0000";
    "urxvt*color10 " = "#8AE234";
    "urxvt*color11 " = "#FCE94F";
    "urxvt*color12 " = "#729FCF";
    "urxvt*color13 " = "#AD7FA8";
    "urxvt*color14 " = "#34E2E2";
    "urxvt*color15 " = "#EEEEEC";
    "urxvt*color2  " = "#4E9A06";
    "urxvt*color3  " = "#C4A000";
    "urxvt*color4  " = "#3465A4";
    "urxvt*color5  " = "#75507B";
    "urxvt*color6  " = "#06989A";
    "urxvt*color7  " = "#D3D7CF";
    "urxvt*color8  " = "#555753";
    "urxvt*color9  " = "#EF2929";

    "URxvt.urgentOnBell" = "true";

    "urxvt.perl-ext-common" = "default,matcher,xkr-clipboard";
    "urxvt.perl-ext" = "font-size";

    # Font size
    "URxvt.keysym.C-equal" = "perl:font-size:increase";

    # Matcher
    "URxvt.keysym.M-u" = "matcher:select";
    "urxvt.urlLauncher" = "xdg-open";
    "urxvt.url-launcher" = "xdg-open";
    "urxvt.matcher.button" = "1";

    # Clipboard
    "URxvt.iso14755" = "false";
    "URxvt.keysym.Shift-Control-C" = "perl:clipboard:copy";
    "URxvt.keysym.Control-Insert" = "perl:clipboard:copy";
  };
}
