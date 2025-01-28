{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.gaming;
in
{
  options.my.roles.gaming = {
    enable = lib.mkEnableOption "Gaming computer";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (wineWowPackages.full.override {
        wineRelease = "staging";
        mingwSupport = true;
      })
      winetricks
    ];

    hardware.graphics.enable32Bit = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    networking.firewall.allowedTCPPorts = [
      7777
    ];
    networking.firewall.allowedUDPPorts = [
      7
      9
      7777
    ];

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    # Steam games SSL fix.
    #
    # Some games like Drawful 2 are statically linked with a version of openssl
    # which, for some reason, cannot use the bundled
    # /etc/ssl/certs/ca-certificates.crt file, but instead looks up the
    # unbundled/hashed version of the same certificate. NixOS does not provide
    # this hashed certificate by default (see discussion in
    # https://github.com/NixOS/nixpkgs/pull/303265). We work around this by
    # extracting the cacert.hashed certificates to /etc/ssl/certs, which the
    # game looks up.
    environment.etc = let
      hashed = "${pkgs.cacert.hashed}/etc/ssl/certs";
    in lib.mapAttrs' (name: _: {
      name = "ssl/certs/${name}";
      value = {
        source = "${hashed}/${name}";
      };
    }) (builtins.readDir hashed);
  };
}
