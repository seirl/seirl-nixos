{ config, lib, pkgs, ... }:

let
  mod = "Mod4";
in
{
  config.xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = "Mod4";
      keybindings = lib.mkOptionDefault {
        # Workspace moves
        "${mod}+Ctrl+Left" = "move workspace to output left";
        "${mod}+Ctrl+Down" = "move workspace to output down";
        "${mod}+Ctrl+Up" = "move workspace to output up";
        "${mod}+Ctrl+Right" = "move workspace to output right";

        # Volume
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +3% && pkill -SIGUSR1 i3status";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -3% && pkill -SIGUSR1 i3status";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && pkill -SIGUSR1 i3status";
        "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && pkill -SIGUSR1 i3status";
        "${mod}+equal" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +3% && pkill -SIGUSR1 i3status";
        "${mod}+minus" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -3% && pkill -SIGUSR1 i3status";
        "${mod}+backslash" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && pkill -SIGUSR1 i3status";

        # Player control with MPRIS D-Bus
        "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioStop" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl stop";
        "XF86AudioPrev" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
        "XF86AudioNext" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";

        # File manager
        "${mod}+a" = "exec ``${pkgs.pcmanfm}/bin/pcmanfm \"`${pkgs.xcwd}/bin/xcwd`\"``";

        # Lock & suspend
        "${mod}+o" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -c 000000";
        "${mod}+Shift+o" = "exec --no-startup-id sudo systemctl suspend & ${pkgs.i3lock}/bin/i3lock -c 000000";

        # Emojis
        "${mod}+semicolon" = "exec --no-startup-id ${pkgs.rofimoji}/bin/rofimoji";

        # Screenshots
        "${mod}+Print" = "exec --no-startup-id ${pkgs.escrotum}/bin/escrotum -C -s";

        # xcwd terminal
        "${mod}+Shift+Return" = "exec ``i3-sensible-terminal -cd \"`${pkgs.xcwd}/bin/xcwd`\"``";

        # Remap to vim-like (commented out for now, might bring back later)
        # Focus
        # "${mod}+h" = "focus left";
        # "${mod}+j" = "focus down";
        # "${mod}+k" = "focus up";
        # "${mod}+l" = "focus right";

        # # Move
        # "${mod}+Shift+h" = "move left";
        # "${mod}+Shift+j" = "move down";
        # "${mod}+Shift+k" = "move up";
        # "${mod}+Shift+l" = "move right";

        # Replace mod+h for horizontal split (used by focus keys)
        # "${mod}+g" = "split h";

      };

      bars = [
        {
          statusCommand = "${pkgs.i3status}/bin/i3status";
          position = "top";
        }
      ];
    };
  };


  config.programs.i3status = {
    enable = true;
    general.interval = 1;
    modules = {
      ipv6.enable = false;
      "disk /".enable = false;
      "memory".enable = false;

      # TODO: configure depending on laptop
      # "battery all".enable = false;

      "wireless _first_" = {
        enable = true;
        settings = {
          format_up = "W: (%quality at %essid) %ip";
          format_down = "W: ø";
        };
      };

      "ethernet _first_" = {
        enable = true;
        settings = {
          format_up = "E: %ip (%speed)";
          format_down = "E: ø";
        };
      };

      "volume master" = {
        enable = true;
        position = 7;
      };
    };
  };
}
