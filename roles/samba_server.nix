{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.samba_server;
in
{
  options = {
    my.roles.samba_server.enable = lib.mkEnableOption "Samba server";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cifs-utils
    ];

    services.samba-wsdd.enable = true;
    networking.firewall.allowedTCPPorts = [
      445
      139
      5357
    ];
    networking.firewall.allowedUDPPorts = [
      137
      138
      3702
    ];
    services.samba = {
      enable = true;
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
        hosts allow = 192.168. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';
      shares = {
        media = {
          public = "yes";
          path = "/srv/data1/seirl/media";
          browseable = "yes";
          "read only" = "yes";
          "only guest" = "yes";
        };
      };
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
      extraServiceFiles = {
        smb = ''
          <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
          <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
          <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
          </service-group>
        '';
      };
    };
  };
}
