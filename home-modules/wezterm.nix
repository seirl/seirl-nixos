{ config, lib, pkgs, ... }:

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
        wezterm.on('bell', function(window, pane)
          -- Only alert if the window is not currently focused
          if not window:is_focused() then
            if os.getenv('WAYLAND_DISPLAY') then
              window:toast_notification('WezTerm', 'Bell rung in ' .. pane:get_title(), nil, 4000)
            elseif os.getenv('DISPLAY') then
              wezterm.background_child_process {
                '${pkgs.wmctrl}/bin/wmctrl',
                '-r',
                pane:get_title(),
                '-b',
                'add,demands_attention',
              }
            end
          end
        end)

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
          audible_bell = "Disabled",
        }
      '';
    };
  };
}
