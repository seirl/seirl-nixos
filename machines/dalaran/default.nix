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

  my.roles.gaming.enable = true;
  my.roles.graphical.enable = true;
  my.roles.nvidia.enable = true;
  my.roles.samba_server.enable = true;
  my.roles.smartd.enable = true;

  environment.systemPackages = with pkgs; [
    anki-bin
    config.nur.repos.k3a.ib-tws
    # (openai-whisper.override { cudaSupport = true; })
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.fwupd.enable = true;

  time.timeZone = "Europe/Zurich";
}
