{ name, config, pkgs, ... }:

let
  my = import ../..;
in
{
  imports = [
    my.modules
    ./hardware.nix
    ./network.nix
    ./printer.nix
  ];

  my.roles.vpn-peer.enable = true;

  my.roles.ecryptfs.enable = true;
  my.roles.gaming.enable = true;
  my.roles.graphical.enable = true;
  my.roles.nvidia.enable = true;
  my.roles.samba_server.enable = true;

  environment.systemPackages = with pkgs; [
    anki-bin
    config.nur.repos.k3a.ib-tws
    # (openai-whisper.override { cudaSupport = true; })
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Zurich";

  nixpkgs.config.cudaCapabilities = [ "5.2" ];
}
