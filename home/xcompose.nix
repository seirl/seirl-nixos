{ config, lib, ... }:

let
  cfg = config.my.home.xcompose;
in
{
  options = {
    my.home.xcompose.enable = lib.mkEnableOption "Enable XCompose config";
  };

  config = lib.mkIf cfg.enable {
    home.file.".XCompose".source = ./source/xcompose.conf;
  };
}
