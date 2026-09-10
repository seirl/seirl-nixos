{ config, lib, pkgs, name, fleet, ... }:

let
  cfg = config.my.roles.vpn-peer;

  machineName = name;
  wgNet = fleet.network.wireguard;
  server = wgNet.server;
  port = wgNet.port;

  allPeers = lib.filterAttrs (_: h: h ? wireguard) fleet.hosts;

  peerIpv4 = id: "${wgNet.subnet4}.${toString id}";
  peerIpv6 = id: "${wgNet.subnet6}::${toString id}";
  peerIpv4WithMask = id: mask: "${peerIpv4 id}/${toString mask}";
  peerIpv6WithMask = id: mask: "${peerIpv6 id}/${toString mask}";

  thisPeer = allPeers."${machineName}" or null;
  otherPeers = lib.filterAttrs (n: v: n != machineName) allPeers;
  # Server must know all peers, clients must only know the ones with external
  # IPs (so that they route through the server otherwise).
  relevantPeers = lib.filterAttrs
    (n: v:
      (machineName == server) || (v.wireguard ? externalIp))
    otherPeers;
in
{
  options.my.roles.vpn-peer = {
    enable = lib.mkEnableOption "VPN peer";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."wireguard/private_key" = {
      sopsFile = ../secrets/machines + "/${machineName}/wireguard.yaml";
    };
    networking.firewall = {
      allowedUDPPorts = [ port ];
      checkReversePath = false;
    };

    networking.wireguard.interfaces = {
      wgseirl = {
        listenPort = port;
        privateKeyFile = config.sops.secrets."wireguard/private_key".path;
        ips = [
          (peerIpv4WithMask thisPeer.wireguard.id 32)
          (peerIpv6WithMask thisPeer.wireguard.id 128)
        ];
        peers = lib.mapAttrsToList
          (
            peerName: peer:
              {
                name = peerName;
                allowedIPs = (if peerName == server then [
                  "${wgNet.subnet4}.0/${toString wgNet.mask4}"
                  "${wgNet.subnet6}::0/${toString wgNet.mask6}"
                ] else [
                  (peerIpv4WithMask peer.wireguard.id 32)
                  (peerIpv6WithMask peer.wireguard.id 128)
                ]);
                publicKey = peer.wireguard.publicKey;
              }
              // lib.optionalAttrs (peer.wireguard ? externalIp) {
                endpoint = "${peer.wireguard.externalIp}:${toString port}";
              }
              // lib.optionalAttrs (!(thisPeer.wireguard ? externalIp)) {
                persistentKeepalive = 10;
              }
          )
          relevantPeers;
      };
    };

    networking.extraHosts = lib.strings.concatLines
      (lib.mapAttrsToList
        (peerName: peer: (lib.strings.concatLines [
          "${peerIpv4 peer.wireguard.id} ${peerName}.${fleet.network.domain} ${peerName}"
          "${peerIpv6 peer.wireguard.id} ${peerName}.${fleet.network.domain} ${peerName}"
        ]))
        allPeers);
  };
}
