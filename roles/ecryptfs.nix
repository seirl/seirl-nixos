{ config, pkgs, ... }:

{
  boot.kernelModules = [ "ecryptfs" ];
  boot.supportedFilesystems = [ "ecryptfs" ];
}
