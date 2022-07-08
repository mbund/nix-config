{ lib, pkgs, modulesPath, options, ... }: {
  imports = [
    "${modulesPath}/profiles/all-hardware.nix"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-install";
  networking.networkmanager.enable = true;
  networking.wireless.enable = lib.mkForce false;
  networking.useDHCP = false;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  users.mutableUsers = false;
  users.users.root.password = "root";
  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "nixos";
  users.users.nixos = {
    password = "nixos";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "users" ];
  };

  console.packages = options.console.packages.default ++ [ pkgs.terminus_font ];

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

    gparted
    firefox
  ];

  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    nssmdns = true;
    publish = { enable = true; domain = true; addresses = true; };
  };

  services.logind.lidSwitch = "ignore";
  system.stateVersion = lib.trivial.release;
}
