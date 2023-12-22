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
    corplaptop = {
      clientNum = 4;
      publicKey = "ZdOiH8yr7BgxNumDplU6/Yn+uqQzSnSolAfqn/NG1mo=";
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
  server = "hyjal";

  peerIpv4 = clientNum: "${wgcfg.subnet4}.${toString clientNum}";
  peerIpv6 = clientNum: "${wgcfg.subnet6}::${toString clientNum}";
  peerIpv4WithMask = clientNum: mask: "${peerIpv4 clientNum}/${toString mask}";
  peerIpv6WithMask = clientNum: mask: "${peerIpv6 clientNum}/${toString mask}";

  thisPeer = allPeers."${machineName}" or null;
  otherPeers = lib.filterAttrs (n: v: n != machineName) allPeers;
  # Server must know all peers, clients must only know the ones with external
  # IPs (so that they route through the server otherwise).
  relevantPeers = lib.filterAttrs
    (n: v:
      (machineName == server) || (v ? externalIp))
    otherPeers;
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
      checkReversePath = false;
    };

    networking.wireguard.interfaces = {
      wgseirl = {
        listenPort = 51820;
        privateKeyFile = config.sops.secrets."wireguard/private_key".path;
        ips = [
          (peerIpv4WithMask thisPeer.clientNum 32)
          (peerIpv6WithMask thisPeer.clientNum 128)
        ];
        peers = lib.mapAttrsToList
          (
            peerName: peer:
              {
                name = peerName;
                allowedIPs = (if peerName == server then [
                  "${wgcfg.subnet4}.0/24"
                  "${wgcfg.subnet6}::0/64"
                ] else [
                  (peerIpv4WithMask peer.clientNum 32)
                  (peerIpv6WithMask peer.clientNum 128)
                ]);
                publicKey = peer.publicKey;
              }
              // lib.optionalAttrs (peer ? externalIp) {
                endpoint = "${peer.externalIp}:${toString port}";
              }
              // lib.optionalAttrs (!(thisPeer ? externalIp)) {
                persistentKeepalive = 10;
              }
          )
          relevantPeers;
      };
    };

    networking.extraHosts = lib.strings.concatLines
      (lib.mapAttrsToList
        (peerName: peer: (lib.strings.concatLines [
          "${peerIpv4 peer.clientNum} ${peerName}.${wgcfg.domain} ${peerName}"
          "${peerIpv6 peer.clientNum} ${peerName}.${wgcfg.domain} ${peerName}"
        ]))
        allPeers);
  };
}
