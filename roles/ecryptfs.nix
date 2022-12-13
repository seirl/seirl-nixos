{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ecryptfs
    ecryptfs-helper
    keyutils
  ];

  boot.kernelModules = [ "ecryptfs" ];
  boot.supportedFilesystems = [ "ecryptfs" ];
}
