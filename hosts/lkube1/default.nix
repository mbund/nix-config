{
  imports = [
    ../../core
    ../../core/kubernetes.nix
    ../../hardware/linode.nix
  ];

  networking.hostName = "lkube1";

  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2kbXZV9yOofK3s37lz5DDogOIp9EKuUxaOhVdczKDr"
  ];
}
