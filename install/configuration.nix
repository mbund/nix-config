{ pkgs, modulesPath, ... }: {
  imports = [
    "${modulesPath}/profiles/all-hardware.nix"
  ];

  networking.hostName = "nixos-install";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  users.mutableUsers = false;
  users.users.root.password = "root";
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    nssmdns = true;
    publish = { enable = true; domain = true; addresses = true; };
  };


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

  services.logind.lidSwitch = "ignore";
  boot.loader.systemd-boot.enable = true;
  system.stateVersion = "22.05";
}
