{ pkgs, modulesPath, ... }: {
  imports = [
    "${modulesPath}/profiles/all-hardware.nix"
  ];

  networking.hostName = "nixos-install";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  users.mutableUsers = false;
  users.users.root.password = "root";
  services.getty.autologinUser = "nixos";
  users.users.nixos = {
    password = "nixos";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "users" "video" ];
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
  system.stateVersion = "22.05";
}
