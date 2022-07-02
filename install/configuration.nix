{ config, pkgs, modulesPath, ... }: {
  imports = [
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  networking.hostName = "nixos-install";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  users.mutableUsers = false;
  users.users.root.password = "root";
  services.getty.autologinUser = "mbund";
  users.groups.mbund.gid = config.users.users.mbund.uid;
  users.users.mbund = {
    password = "mbund";
    createHome = true;
    isNormalUser = true;
    group = "mbund";
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "users" "video" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2kbXZV9yOofK3s37lz5DDogOIp9EKuUxaOhVdczKDr"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  security.doas.wheelNeedsPassword = false;
  security.doas.enable = true;
  security.doas.extraRules = [
    { groups = [ "wheel" ]; noPass = true; keepEnv = true; }
  ];

  nix.extraOptions = "experimental-features = nix-command flakes recursive-nix";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    ncdu
    file
    htop
    vim
    helix
    openssl
    pciutils
    tmux
    unar
    zip
  ];

  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    nssmdns = true;
    publish = { enable = true; domain = true; addresses = true; };
  };

  services.logind.lidSwitch = "ignore";
  boot.loader.systemd-boot.enable = true;
  system.stateVersion = "22.05";
}
