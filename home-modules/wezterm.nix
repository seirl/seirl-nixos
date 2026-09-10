{ config, lib, ... }:

let
  cfg = config.my.home.wezterm;
in
{
  options = {
    my.home.wezterm.enable = lib.mkEnableOption "Enable wezterm config";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        return {
          font = wezterm.font_with_fallback {
              "DejaVu Sans Mono",
              "Noto Color Emoji",
              "Symbola",
          },
          window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
          },
          colors = {
            cursor_bg = 'white',
            cursor_border = 'white',
          },
          color_scheme = "Gnometerm (terminal.sexy)",
          font_size = 8.5,
          freetype_load_target = "Light",
          enable_tab_bar = false,
          window_close_confirmation = "NeverPrompt",
        }
      '';
    };
  };
}
