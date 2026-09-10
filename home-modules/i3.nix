{ config, lib, pkgs, ... }:

let
  mod = "Mod4";
  cfg = config.my.home.i3;

  pactl = lib.getExe' pkgs.pulseaudio "pactl";
  playerctl = lib.getExe pkgs.playerctl;
in
{
  options = {
    my.home.i3 = {
      enable = lib.mkEnableOption "Enable i3 config";
      showBattery = lib.mkEnableOption "Show battery status";
    };
  };

  config = lib.mkIf cfg.enable {
    xsession.windowManager.i3 = {
      enable = true;

      config = {
        modifier = "Mod4";
        defaultWorkspace = "workspace number 1";
        keybindings = lib.mkOptionDefault {
          # Workspace moves
          "${mod}+Ctrl+Left" = "move workspace to output left";
          "${mod}+Ctrl+Down" = "move workspace to output down";
          "${mod}+Ctrl+Up" = "move workspace to output up";
          "${mod}+Ctrl+Right" = "move workspace to output right";

          # Volume
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ +3% && pkill -SIGUSR1 i3status";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ -3% && pkill -SIGUSR1 i3status";
          "XF86AudioMute" = "exec --no-startup-id ${pactl} set-sink-mute @DEFAULT_SINK@ toggle && pkill -SIGUSR1 i3status";
          "XF86AudioMicMute" = "exec --no-startup-id ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle && pkill -SIGUSR1 i3status";
          "${mod}+equal" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ +3% && pkill -SIGUSR1 i3status";
          "${mod}+minus" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ -3% && pkill -SIGUSR1 i3status";
          "${mod}+backslash" = "exec --no-startup-id ${pactl} set-sink-mute @DEFAULT_SINK@ toggle && pkill -SIGUSR1 i3status";

          # Player control with MPRIS D-Bus
          "XF86AudioPlay" = "exec --no-startup-id ${playerctl} play-pause";
          "XF86AudioStop" = "exec --no-startup-id ${playerctl} stop";
          "XF86AudioPrev" = "exec --no-startup-id ${playerctl} previous";
          "XF86AudioNext" = "exec --no-startup-id ${playerctl} next";

          # File manager
          "${mod}+a" = "exec ``${lib.getExe pkgs.pcmanfm} \"`${lib.getExe pkgs.xcwd}`\"``";

          # Lock & suspend
          "${mod}+o" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -c 000000";
          "${mod}+Shift+o" = "exec --no-startup-id sudo systemctl suspend & ${lib.getExe pkgs.i3lock} -c 000000";

          # Emojis
          "${mod}+semicolon" = "exec --no-startup-id ${lib.getExe pkgs.rofimoji}";

          # Screenshots
          "${mod}+Print" = "exec --no-startup-id ${lib.getExe pkgs.escrotum} -C -s";

          # xcwd terminal
          "${mod}+Shift+Return" = "exec ``${lib.getExe' pkgs.i3 "i3-sensible-terminal"} -cd \"`${lib.getExe pkgs.xcwd}`\"``";

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
            statusCommand = "${lib.getExe pkgs.i3status}";
            position = "top";
          }
        ];
      };

      extraConfig = ''
        for_window [class="^Steam$" title="^Friends$"] floating enable
        for_window [class="^Steam$" title="Steam - News"] floating enable
        for_window [class="^Steam$" title=".* - Chat"] floating enable
        for_window [class="^Steam$" title="^Settings$"] floating enable
        for_window [class="^Steam$" title=".* - event started"] floating enable
        for_window [class="^Steam$" title=".* CD key"] floating enable
        for_window [class="^Steam$" title="^Steam - Self Updater$"] floating enable
        for_window [class="^Steam$" title="^Screenshot Uploader$"] floating enable
        for_window [class="^Steam$" title="^Steam Guard - Computer Authorization Required$"] floating enable
        for_window [title="^Steam Keyboard$"] floating enable
      '';
    };


    programs.i3status = {
      enable = true;
      general.interval = 1;
      modules = {
        ipv6.enable = false;
        "disk /".enable = false;
        "memory".enable = false;

        "battery all".enable = cfg.showBattery;

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
  };
}
