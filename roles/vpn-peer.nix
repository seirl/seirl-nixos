{ config, lib, pkgs, name, ... }:

let
  cfg = config.my.roles.vpn-peer;

  machineName = name;
  port = 51820;
  allPeers = {
    hyjal = {
      clientNum = 1;
      externalIp = "95.216.87.10";
      publicKey = "BmectuKYQgE0CHyfU8OlKyxfwXSds6JustGUEJCnYUs=";
      sopsFile = ../secrets/machines/hyjal/wireguard.yaml;
    };
    redridge = {
      clientNum = 3;
      publicKey = "WjYll9aqjlQGc9x1Pqs0ieLjBA6fc4+jWDQIzo3qdzE=";
      sopsFile = ../secrets/machines/redridge/wireguard.yaml;
    };
  };
  wgcfg = {
    domain = "seirl.local";
    subnet4 = "10.100.0";
    subnet6 = "fdd2:cdae:f4b4:ad0d";
    mask4 = 24;
    mask6 = 64;
  };

  peerIpv4 = clientNum: "${wgcfg.subnet4}.${toString clientNum}";
  peerIpv6 = clientNum: "${wgcfg.subnet6}::${toString clientNum}";
  peerIpv4WithMask = clientNum: mask: "${peerIpv4 clientNum}/${toString mask}";
  peerIpv6WithMask = clientNum: mask: "${peerIpv6 clientNum}/${toString mask}";

  thisPeer = allPeers."${machineName}" or null;
  otherPeers = lib.filterAttrs (n: v: n != machineName) allPeers;
in
{
  options.my.roles.vpn-peer = {
    enable = lib.mkEnableOption "VPN peer";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."wireguard/private_key" = {
      sopsFile = thisPeer.sopsFile;
    };
    networking.firewall = {
      allowedUDPPorts = [ 51820 ];
    };
    networking.wireguard.interfaces = {
      wgseirl = {
        listenPort = 51820;
        privateKeyFile = config.sops.secrets."wireguard/private_key".path;
        ips = [
          (peerIpv4WithMask thisPeer.clientNum wgcfg.mask4)
          (peerIpv6WithMask thisPeer.clientNum wgcfg.mask6)
        ];
        peers = lib.mapAttrsToList
          (
            name: peer:
              {
                inherit name;
                allowedIPs = [
                  (peerIpv4WithMask peer.clientNum 32)
                  (peerIpv6WithMask peer.clientNum 128)
                ];
                publicKey = peer.publicKey;
              }
              // lib.optionalAttrs (peer ? externalIp) {
                endpoint = "${peer.externalIp}:${toString port}";
              }
              // lib.optionalAttrs (!(thisPeer ? externalIp)) {
                persistentKeepalive = 10;
              }
          )
          otherPeers;
      };
    };

    networking.extraHosts = lib.strings.concatLines
      (lib.mapAttrsToList
        (name: peer: (lib.strings.concatLines [
          "${peerIpv4 peer.clientNum} ${name}.${wgcfg.domain} ${name}"
          "${peerIpv6 peer.clientNum} ${name}.${wgcfg.domain} ${name}"
        ]))
        allPeers);
  };
}
