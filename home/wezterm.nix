{ config, lib, ... }:

let
  cfg = config.my.home.alacritty;
in
{
  options = {
    my.home.alacritty.enable = lib.mkEnableOption "Enable alacritty config";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal.family = "DejaVu Sans Mono";
          size = 8.5;
        };

        colors = {
          primary = {
            foreground = "#ffffff";
            background = "#000000";
          };
          normal = {
            black = "#2e3436";
            red = "#cc0000";
            green = "#4e9a06";
            yellow = "#c4a000";
            blue = "#3465a4";
            magenta = "#75507b";
            cyan = "#06989a";
            white = "#d3d7cf";
          };
          bright = {
            black = "#555753";
            red = "#ef2929";
            green = "#8ae234";
            yellow = "#fce94f";
            blue = "#729fcf";
            magenta = "#ad7fa8";
            cyan = "#37e2e2";
            white = "#eeeeec";
          };
        };
        draw_bold_text_with_bright_colors = true;
      };
    };
  };
}
