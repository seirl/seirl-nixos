{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.ecryptfs;
in {
  options = {
    my.roles.ecryptfs.enable = lib.mkEnableOption "Ecryptfs mount and tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ecryptfs
      ecryptfs-helper
      keyutils
    ];

    boot.kernelModules = [ "ecryptfs" ];
    boot.supportedFilesystems = [ "ecryptfs" ];

    nixpkgs.config.permittedInsecurePackages = [
      "python-2.7.18.6"
    ];
  };
}
