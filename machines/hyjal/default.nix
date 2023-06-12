{ name, config, pkgs, ... }:

let
  my = import ../..;
in
{
  imports = [
    my.modules
    ./hardware.nix
  ];

  my.roles.nginx.enable = true;
  my.roles.badeconomics.enable = true;
  my.roles.crowdbar = {
    enable = true;
    vhost = "crowdbar.koin.fr";
  };
  my.roles.epiquote = {
    enable = true;
    vhost = "epiquote.fr";
  };
  my.roles.seedbox = {
    enable = true;
    vhost = "torrent.koin.fr";
  };
  my.roles.irc-client = {
    enable = true;
    vhost = "weechat.koin.fr";
    users = [ config.users.users.seirl ];
  };

  # Pin version, upgrades are manual.
  services.postgresql.package = pkgs.postgresql_14;

  deployment.targetHost = "hyjal.koin.fr";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.useDHCP = true;

  # idk how to make that work
  # systemd.network.enable = true;
  # systemd.network.networks."10-uplink" = {
  #   matchConfig.Name = "enp1s0";
  #   networkConfig = {
  #     Address = "2a01:4f9:2b:c90:d000::1/64";
  #     DHCP = "yes";
  #     IPv6AcceptRA = false;
  #     DHCPPrefixDelegation = true;
  #   };
  #   dhcpV6Config = {
  #     WithoutRA = "solicit";
  #     PrefixDelegationHint = "::/128";
  #   };
  # };

  time.timeZone = "UTC";
}
