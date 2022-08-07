{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    dogdns
  ];

  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [
      config.services.tailscale.port

      5353 # systemd-resolved
      5355 # systemd-resolved
    ];
    allowedTCPPorts = [
      5355 # systemd-resolved
    ];
  };

  networking.useDHCP = false;
  networking.wireguard.enable = true;
  networking.networkmanager.enable = true;

  services.resolved.enable = true;
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
  systemd.services.tailscaled.after = ["network-online.target" "systemd-resolved.service"];

  environment.persistence."/state".directories = [
    "/etc/NetworkManager/system-connections"
    "/var/lib/tailscale"
  ];
}
