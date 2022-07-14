{ pkgs, ... }: {
  imports = [
    ../../core

    ../../hardware/linode.nix
  ];

  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2kbXZV9yOofK3s37lz5DDogOIp9EKuUxaOhVdczKDr"
  ];

  # This is required so that pod can reach the API server (running on port 6443 by default)
  networking.firewall.allowedTCPPorts = [ 6443 ];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = builtins.toString [
    "--kubelet-arg=v=4" # logging level
  ];
  environment.systemPackages = [ pkgs.k3s ];
}
