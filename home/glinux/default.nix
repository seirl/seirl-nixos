{ config, pkgs, lib, ... }:

let
  cfg = config.my.home.glinux;
  backupConfigFile =
    "${config.xdg.configHome}/goobuntu-backups/exclude.d/seirl-config";
in
{
  options = {
    my.home.glinux.enable = lib.mkEnableOption "Enable gLinux config";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "glinux-seirl-thinkpad-bios-config" ''
        sudo biosmgr set \
            FnCtrlKeySwap Enable \
            FnKeyAsPrimary Enable \
            SleepState Linux \
      '')
    ];

    home.file."${backupConfigFile}".text = ''
      media/*
      Downloads/*.mkv
      Downloads/*.avi
      Downloads/*.mp4
      Downloads/*.iso
    '';

    programs.zsh.initExtra = ''
        for file in \
          /etc/bash_completion.d/p4 \
          /etc/bash_completion.d/g4d \
          /etc/bash_completion.d/flex.par \
          /etc/bash_completion.d/hgd \
        ; do
            test -f "$file" && source "$file"
        done
    '';
  };
}
