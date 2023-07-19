{
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
}
