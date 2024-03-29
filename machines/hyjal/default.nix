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
  my.roles.monitoring = {
    enable = true;
    vhost = "grafana.koin.fr";
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
  my.roles.webuser = {
    enable = true;
    vhost = "koin.fr";
    user = config.users.users.seirl;
  };

  # Pin version, upgrades are manual.
  services.postgresql.package = pkgs.postgresql_14;

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9002;
  };

  deployment.targetHost = "hyjal.koin.fr";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  time.timeZone = "UTC";
}
