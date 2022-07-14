{ lib, pkgs, ... }: {
  imports = [
    ../../core

    ../../hardware/linode.nix
  ];

  networking.hostName = "lkube1";

  environment.systemPackages = with pkgs; [
    k3s
  ];

  networking.firewall.allowedTCPPorts = [ 6443 ];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = builtins.toString [
    "--kubelet-arg=v=4" # logging level
  ];

  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2kbXZV9yOofK3s37lz5DDogOIp9EKuUxaOhVdczKDr"
  ];

  environment.persistence = lib.mkForce null;
}
