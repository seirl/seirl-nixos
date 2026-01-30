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
            FnCtrlKeySwap Disable \
            FnKeyAsPrimary Enable \
      '')
      (pkgs.writeShellScriptBin "glinux-seirl-setup" ''
        sudo apt install autossh wofi git neovim nix feh eog evince
        sudo tee -a /etc/nix/nix.conf <<< 'experimental-features = nix-command flakes'
        sudo usermod -a -G nix-users $USER
        glinux-seirl-thinkpad-bios-config
      '')
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
        ; do
            test -f "$file" && source "$file"
        done
    '';
  };
}
