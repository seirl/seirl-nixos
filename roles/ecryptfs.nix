{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ecryptfs
    ecryptfs-helper
  ];

  boot.kernelModules = [ "ecryptfs" ];
  boot.supportedFilesystems = [ "ecryptfs" ];
}
