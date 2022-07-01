{ lib, pkgs, modulesPath, ... }: {
  imports = [
    "${modulesPath}/profiles/all-hardware.nix"
  ];

  networking.hostName = "nixos-install";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    initialHashedPassword = "";
  };

  users.users.root.initialHashedPassword = "";

  security.sudo = {
    enable = lib.mkDefault true;
    wheelNeedsPassword = lib.mkForce false;
  };

  services.getty.autologinUser = "nixos";

  services.getty.helpLine = ''
    The "nixos" and "root" accounts have empty passwords.

    An ssh daemon is running. You then must set a password
    for either "root" or "nixos" with `passwd` or add an ssh key
    to /home/nixos/.ssh/authorized_keys be able to login.
  '';

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

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
