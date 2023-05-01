{ name, config, pkgs, ... }:

let
  my = import ../..;
in {
  imports = [
    my.modules
    ./hardware.nix
  ];

  my.roles.ecryptfs.enable = true;
  my.roles.gaming.enable = true;
  my.roles.graphical.enable = true;
  my.roles.nvidia.enable = true;
  my.roles.samba_server.enable = true;

  environment.systemPackages = with pkgs; [
    anki-bin
    (openai-whisper.override { cudaSupport = true; })
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";
}
