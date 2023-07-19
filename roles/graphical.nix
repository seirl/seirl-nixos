{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.graphical;
in
{
  options = {
    my.roles.graphical.enable = lib.mkEnableOption "Graphical computer";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      i3
      rxvt-unicode
      pavucontrol
      xorg.xkill
      xorg.xev

      pcmanfm
      lxmenu-data
      shared-mime-info
      gnome.adwaita-icon-theme
      xfce.tumbler

      google-chrome
      firefox
      mpv
      vlc
      feh
      evince
      rofimoji
      escrotum
      imgurbash2
      transmission-qt
      virt-manager

      aegisub
      audacity
      gimp-with-plugins
    ];

    services.xserver.enable = true;

    services.xserver.displayManager.sddm.enable = true;
    services.xserver.windowManager.i3.enable = true;

    hardware.opengl.enable = true;

    # Configure keymap in X11
    services.xserver.layout = "us";
    services.xserver.xkbVariant = "altgr-intl";
    services.xserver.xkbOptions = "compose:menu,caps:swapescape";

    # dconf for programs that use GSettings.
    programs.dconf.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.support32Bit = true;

    # Enable NetworkManager applet
    programs.nm-applet.enable = true;

    # GVFS to mount MTP devices
    services.gvfs.enable = true;
  };
}
