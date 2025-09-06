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
          font_size = 9.0,
          color_scheme = "Tango (terminal.sexy)",
          enable_tab_bar = false,
          window_close_confirmation = "NeverPrompt",
        }
      '';

      # font = {
      #   size = 8.5;
      #   name = "DejaVu Sans Mono";
      # };
      # theme = "Tango Dark";
      # settings = {
      #   confirm_os_window_close = "0";
      # };
    };
  };
}
