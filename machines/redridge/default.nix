{ name, config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../roles/graphical.nix
    ../../roles/nvidia_legacy_470.nix
    ../../roles/gaming.nix
    ../../roles/ecryptfs.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";


  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
}
