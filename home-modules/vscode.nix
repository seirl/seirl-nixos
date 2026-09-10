{ config, lib, ... }:

let
  cfg = config.my.home.vscode;
in
{
  options = {
    my.home.vscode.enable = lib.mkEnableOption "Enable VSCode config";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      profiles.default.userSettings = {
        "keyboard.dispatch" = "keyCode";
        "window.zoomLevel" = -1;
      };
    };
  };
}
