{ config, pkgs, ... }:

{
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

}
