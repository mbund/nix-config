{pkgs, ...}: {
  imports = [
    ../../core
    ../../core/virtualisation.nix

    ./hardware-configuration.nix

    ../../graphics
    # ../../graphics/hyprland.nix

    ../../users/mbund
  ];

  networking.hostName = "kumitate";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.wacom.enable = true;
  services.flatpak.enable = true;
  services.packagekit.enable = true;
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.jack.enable = true;
  services.pipewire.pulse.enable = true;
  hardware.pulseaudio.enable = false;
  services.power-profiles-daemon.enable = false;

  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.avahi.nssmdns = true;
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    hplip
  ];

  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;

  programs.steam.enable = true;
  programs.wireshark.enable = true;
  programs.adb.enable = true;
  virtualisation.waydroid.enable = true;
  programs.evolution.enable = true;
  programs.evolution.plugins = [pkgs.evolution-ews];
  services.fwupd.enable = true;

  security.pam.yubico.enable = true;
  security.pam.yubico.mode = "challenge-response";
  security.pam.services.login.fprintAuth = true;
  security.pam.services.xscreensaver.fprintAuth = true;
  security.pam.services.xlock.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.max-jobs = 16;
  nix.settings.system-features = ["benchmark" "nixos-test" "big-parallel" "kvm"];

  users.users.root.password = "root";
}
