{ name, config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../roles/graphical.nix
    ../../roles/nvidia.nix
    ../../roles/gaming.nix
    ../../roles/ecryptfs.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";
}
