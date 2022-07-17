{ lib, ... }: {
  networking.firewall.allowedTCPPorts = [ 6443 ];
  services.k3s.enable = true;
  services.k3s.role = lib.mkDefault "server";
  services.k3s.extraFlags = builtins.toString [
    "--kubelet-arg=v=4" # logging level
  ];
}
