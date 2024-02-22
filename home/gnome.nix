{ config, pkgs, lib, ... }:

let
  cfg = config.my.home.gnome;
in
{
  options = {
    my.home.gnome.enable = lib.mkEnableOption "Enable gnome config";
  };

  config = lib.mkIf cfg.enable {
    my.home.gnome-terminal.enable = true;

    dconf.enable = true;
    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "caps:swapescape" ];
        sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us+altgr-intl" ]) ];
      };

      "org/gnome/desktop/wm/preferences" = {
        audible-bell = false;
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = "false";
      };

      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = false;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        natural-scroll = false;
      };

      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Shift><Super>q" ];
        move-to-monitor-down = [ "<Control><Super>Down" ];
        move-to-monitor-left = [ "<Control><Super>Left" ];
        move-to-monitor-right = [ "<Control><Super>Right" ];
        move-to-monitor-up = [ "<Control><Super>Up" ];
        move-to-workspace-1 = [ "<Shift><Super>1" ];
        move-to-workspace-2 = [ "<Shift><Super>2" ];
        move-to-workspace-3 = [ "<Shift><Super>3" ];
        move-to-workspace-4 = [ "<Shift><Super>4" ];
        switch-applications = [ "<Super>Tab" ];
        switch-applications-backward = [ "<Shift><Super>Tab" ];
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-backward = [ "<Shift><Alt>Tab" ];
        toggle-fullscreen = [ "<Super>f" ];
        toggle-maximized = [ "<Shift><Super>space" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        auto-raise = true;
        focus-mode = "sloppy";
        resize-with-right-button = true;
      };

      "org/gnome/mutter" = {
        workspaces-only-on-primary = false;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/wofirun/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofimoji/"
        ];
        help = [ ];
        screensaver = [ "<Super>l" ];
        volume-down = [ "<Super>minus" ];
        volume-mute = [ "<Super>backslash" ];
        volume-up = [ "<Super>equal" ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
        binding = "<Super>Return";
        command = "${pkgs.gnome.gnome-terminal}/bin/gnome-terminal";
        name = "gnome-terminal";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/wofirun" = {
        binding = "<Super>d";
        command = "${pkgs.wofi}/bin/wofi --show run";
        name = "wofi --show run";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofimoji" = {
        binding = "<Super>;";
        command = "${pkgs.rofimoji}/bin/rofimoji --selector ${pkgs.wofi}/bin/wofi";
        name = "rofimoji";
      };
    };

    # Register ssh-askpass to remember my choice to ignore the annoying
    # "disable inhibit shortcuts" prompt warning.
    # https://gitlab.gnome.org/GNOME/seahorse/-/issues/352
    xdg.desktopEntries.ssh-askpass = {
      name = "ssh-askpass";
      genericName = "ssh-askpass";
      type = "Application";
      exec = "/usr/bin/ssh-askpass";
      terminal = false;
    };
  };
}
