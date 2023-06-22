{
  config,
  pkgs,
  ...
}: {
  networking.useDHCP = false;
  networking.wireguard.enable = true;
  networking.networkmanager.enable = true;

  services.resolved.enable = true;
  services.resolved.dnssec = "true";
  services.resolved.extraConfig = ''
    MulticastDNS=true
    DNSOverTLS=yes
  '';
  networking.nameservers = [
    "2620:fe::fe#dns.quad9.net"
    "2620:fe::9#dns.quad9.net"
    "9.9.9.9#dns.quad9.net"
    "149.112.112.112#dns.quad9.net"
  ];

  services.tailscale.enable = true;
  networking.firewall.allowedUDPPorts = [
    41641
  ];

  # networking.nftables.enable = true;
  # networking.nftables.ruleset = ''
  #   table inet mullvad-ts {
  #   chain exclude-outgoing {
  #     type route hook output priority 0; policy accept;
  #     ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
  #     ip6 daddr fd7a:115c:a1e0::/48 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
  #   }
  # 
  #   chain allow-incoming {
  #     type filter hook input priority -100; policy accept;
  #     iifname "tailscale0" ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
  #   }
  # }
  # '';
}
