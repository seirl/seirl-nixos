{ config, lib, pkgs, ... }:

let
  cfg = config.my.home.rclone;
in
{
  options = {
    my.home.rclone = {
      enable = lib.mkEnableOption "Enable rclone config";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."gdrive/token" = {
      path = "${config.xdg.configHome}/rclone/secrets/gdrive/token";
    };

    programs.rclone = {
      enable = true;
      remotes.gdrive = {
        config = {
          type = "drive";
          scope = "drive";
        };
        secrets = {
          token = config.sops.secrets."gdrive/token".path;
        };
        mounts = {
          "/" = {
            enable = true;
            mountPoint = "${config.home.homeDirectory}/gdrive";
            options = {
              read-only = true;
            };
          };
        };
      };
    };
  };
}
