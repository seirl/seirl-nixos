{ config, lib, ... }:

let
  cfg = config.my.home.kitty;
in
{
  options = {
    my.home.kitty.enable = lib.mkEnableOption "Enable kitty config";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        size = 8.5;
        name = "DejaVu Sans Mono";
      };
      theme = "Tango Dark";
      settings = {
        confirm_os_window_close = "0";
      };
    };
  };
}
