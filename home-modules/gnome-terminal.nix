{ config, pkgs, lib, ... }:

let
  cfg = config.my.home.gnome-terminal;
in
{
  options = {
    my.home.gnome-terminal.enable = lib.mkEnableOption "Enable gnome terminal";
  };

  config = lib.mkIf cfg.enable {
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/terminal/legacy" = {
        default-show-menubar = false;
        headerbar = false;
        menu-accelerator-enabled = true;
        mnemonics-enabled = false;
      };

      "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
        visible-name = "seirl";
        audible-bell = false;
        background-color = "rgb(23,20,33)";
        bold-is-bright = true;
        font = "Monospace 11";
        foreground-color = "rgb(208,207,204)";
        palette = [
          "rgb(23,20,33)"
          "rgb(192,28,40)"
          "rgb(38,162,105)"
          "rgb(162,115,76)"
          "rgb(59,146,255)"
          "rgb(163,71,186)"
          "rgb(42,161,179)"
          "rgb(208,207,204)"
          "rgb(94,92,100)"
          "rgb(246,97,81)"
          "rgb(51,218,122)"
          "rgb(233,173,12)"
          "rgb(42,123,222)"
          "rgb(192,97,203)"
          "rgb(51,199,222)"
          "rgb(255,255,255)"
        ];
        scrollbar-policy = "never";
        use-system-font = true;
        use-theme-colors = true;
      };
    };
  };
}
