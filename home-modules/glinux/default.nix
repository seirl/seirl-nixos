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
      (pkgs.writeScriptBin "glinux-seirl-laptop-setup"
        (builtins.readFile ./glinux-seirl-laptop-setup))
    ];

    home.file."${backupConfigFile}".text = ''
      .local/share/flatpak
      .npm
      .venv
      .cache
      .local/share/Trash
      Downloads/**.avi
      Downloads/**.iso
      Downloads/**.mkv
      Downloads/**.mp4
      Downloads/**.srt
      Downloads/**.vtt
      media
      node_modules
      snap
      .config/google-chrome
    '';

    programs.zsh.initExtra = ''
      for file in \
        /etc/bash_completion.d/p4 \
        /etc/bash_completion.d/g4d \
        /etc/bash_completion.d/flex.par \
        /etc/bash_completion.d/hgd \
        /etc/bash_completion.d/jjd \
      ; do
          test -f "$file" && source "$file"
      done
    '';
  };
}
