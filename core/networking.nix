{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dogdns
  ];

  networking = {
    firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [
        config.services.tailscale.port

        5353 # systemd-resolved
        5355 # systemd-resolved
      ];
      allowedTCPPorts = [
        5355 # systemd-resolved
      ];
    };
    useDHCP = false;
    useNetworkd = true;
    wireguard.enable = true;
    networkmanager.dns = "systemd-resolved";
  };

  systemd.network.wait-online.anyInterface = true;
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    extraConfig = ''
      DNS=1.1.1.1 2606:4700:4700::1111 8.8.8.8 2001:4860:4860::8844
      Domains=~.
      LLMNR=true
      MulticastDNS=true
    '';
  };

  system.nssDatabases.hosts = lib.mkMerge [
    (lib.mkBefore [ "mdns_minimal [NOTFOUND=return]" ])
    (lib.mkAfter [ "mdns" ])
  ];

  services.tailscale.enable = true;
  systemd.services.tailscaled.after = [ "network-online.target" "systemd-resolved.service" ];
}
