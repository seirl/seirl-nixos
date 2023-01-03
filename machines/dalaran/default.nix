{ name, config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../roles/ecryptfs.nix
    ../../roles/gaming.nix
    ../../roles/graphical.nix
    ../../roles/nvidia.nix
    ../../roles/samba_server.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";
}
