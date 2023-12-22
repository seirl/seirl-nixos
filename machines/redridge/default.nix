{ name, config, pkgs, ... }:

let
  my = import ../..;
in
{
  imports = [
    my.modules
    ./hardware.nix
    ./network.nix
  ];

  my.roles.vpn-peer.enable = true;

  my.roles.ecryptfs.enable = true;
  my.roles.gaming.enable = true;
  my.roles.graphical.enable = true;
  my.roles.nvidia.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  time.timeZone = "Europe/Paris";
}
