{ lib, pkgs, modulesPath, options, ... }: {
  imports = [
    "${modulesPath}/profiles/all-hardware.nix"
  ];

  networking.hostName = "nixos-install";
  networking.networkmanager.enable = true;
  networking.wireless.enable = lib.mkForce false;
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

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = false;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "nixos";
  services.xserver.desktopManager.gnome = {
    enable = true;
    favoriteAppsOverride = ''
      [org.gnome.shell]
      favorite-apps=[ 'firefox.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'gparted.desktop' ]
    '';

    extraGSettingsOverrides = ''
      [org.gnome.shell]
      welcome-dialog-last-shown-version='9999999999'
      [org.gnome.desktop.session]
      idle-delay=0
      [org.gnome.settings-daemon.plugins.power]
      sleep-inactive-ac-type='nothing'
      sleep-inactive-battery-type='nothing'
    '';

    extraGSettingsOverridePackages = [ pkgs.gnome.gnome-settings-daemon ];
  };

  hardware.pulseaudio.enable = true;

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

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  virtualisation.vmware.guest.enable = true;
  virtualisation.hypervGuest.enable = true;
  services.xe-guest-utilities.enable = true;

  # The VirtualBox guest additions rely on an out-of-tree kernel module
  # which lags behind kernel releases, potentially causing broken builds.
  virtualisation.virtualbox.guest.enable = false;

  services.logind.lidSwitch = "ignore";
  system.stateVersion = lib.trivial.release;
}
