{ name, config, pkgs, ... }:

let
  my = import ../..;
in
{
  imports = [
    my.modules
    ./hardware.nix
  ];

  networking.extraHosts =
    ''
      2a01:4f9:2b:c90:d000::1 koin2.fr
      2a01:4f9:2b:c90:d000::1 torrent.koin2.fr
      2a01:4f9:2b:c90:d000::1 epiquote2.fr
      2a01:4f9:2b:c90:d000::1 rss.koin2.fr
      2a01:4f9:2b:c90:d000::1 weechat.koin2.fr
    '';

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
