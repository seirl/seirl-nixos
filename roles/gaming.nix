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

    # Drawful 2 fix.
    #
    # The game is statically linked with a version of openssl which, for some
    # reason, cannot use the bundled /etc/ssl/certs/ca-certificates.crt file,
    # but instead looks up the unbundled and hashed version of the same
    # certificate. NixOS does not provide this hashed certificate by default,
    # and there is currently no package that provide them.
    # We work around this by simply copying the one certificate required by
    # Drawful 2 from the cacert.unbundled package to the hashed path that the
    # game looks up.
    environment.etc."ssl/certs/f081611a.0" = {
      source = "${pkgs.cacert.unbundled}/etc/ssl/certs/Go_Daddy_Class_2_CA:0.crt";
      mode = "0644";
    };
  };
}
