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
    gocryptfs
    # config.nur.repos.k3a.ib-tws
    # (openai-whisper.override { cudaSupport = true; })
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.fwupd.enable = true;

  time.timeZone = "Europe/Zurich";

  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
  };

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;
    serverProperties = {
      server-port = 25565;
      enable-lan-visibility = true;
      difficulty = "normal";
      gamemode = "survival";
      force-gamemode = true;
      max-players = 5;
      motd = "Miau!";
      allow-cheats = false;
      online-mode = false;
    };
    jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
  };
}
