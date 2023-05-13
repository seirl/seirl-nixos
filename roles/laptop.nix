{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.laptop;
in
{
  options = {
    my.roles.laptop.enable = lib.mkEnableOption "Laptop machine";
  };

  config = lib.mkIf cfg.enable {
    my.home.i3.showBattery = true;
  };
}
