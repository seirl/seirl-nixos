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
      adwaita-icon-theme
      tumbler

      google-chrome
      firefox
      mpv
      vlc
      feh
      evince
      rofimoji
      escrotum
      imgurbash2
      transmission_4-qt
      virt-manager

      aegisub
      audacity
      gimp-with-plugins

      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          bbenoist.nix
          # broken https://github.com/NixOS/nixpkgs/issues/263493
          # ms-python.python
          rust-lang.rust-analyzer
          vscodevim.vim
        ];
      })
    ];

    services.xserver.enable = true;

    services.displayManager.sddm.enable = true;
    services.xserver.windowManager.i3.enable = true;
    programs.i3lock.enable = true;

    hardware.graphics.enable = true;

    # Configure keymap in X11
    services.xserver.xkb.layout = "us";
    services.xserver.xkb.variant = "altgr-intl";
    services.xserver.xkb.options = "compose:menu,caps:swapescape";

    # dconf for programs that use GSettings.
    programs.dconf.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable NetworkManager applet
    programs.nm-applet.enable = true;

    # GVFS to mount MTP devices
    services.gvfs.enable = true;

    # Enable autorandr.
    services.autorandr.enable = true;
  };
}
