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
}
