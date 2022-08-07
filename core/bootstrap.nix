# deploy -s .#HOST --ssh-user nixos --hostname 192.168.1.XXX --magic-rollback false --auto-rollback false
{lib, ...}: {
  users.users = {
    root.password = "nixos";
    nixos = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
      password = "nixos";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2kbXZV9yOofK3s37lz5DDogOIp9EKuUxaOhVdczKDr"
      ];
    };
  };

  security.sudo.enable = lib.mkForce true;
  security.doas.enable = lib.mkForce true;
  security.sudo.wheelNeedsPassword = lib.mkForce false;
  security.doas.wheelNeedsPassword = lib.mkForce false;

  services.openssh.enable = lib.mkForce true;
  services.openssh.permitRootLogin = lib.mkForce "yes";

  system.stateVersion = "22.05";
}
