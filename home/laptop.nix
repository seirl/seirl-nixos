{ config, lib, pkgs, ... }:

let
  cfg = config.my.home.laptop;
in
{
  options = {
    my.home.laptop.enable = lib.mkEnableOption "Laptop machine";
  };

  config = lib.mkIf cfg.enable {
    my.home.i3.showBattery = true;
  };
}
