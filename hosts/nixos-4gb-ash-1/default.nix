{
  imports = [
    ../../core
    ../../core/kubernetes.nix
    ../../hardware/hetzner.nix
  ];

  networking.hostName = "nixos-4gb-ash-1";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2kbXZV9yOofK3s37lz5DDogOIp9EKuUxaOhVdczKDr"
  ];

  boot.cleanTmpDir = true;
  environment.persistence = { };
}
