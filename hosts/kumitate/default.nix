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
  services.printing.enable = true;
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.jack.enable = true;
  services.pipewire.pulse.enable = true;
  hardware.pulseaudio.enable = false;
  services.power-profiles-daemon.enable = false;

  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;
  # powerManagement.powertop.enable = true;
  # services.tlp.enable = true;
  # services.tlp.settings = {
  #   PCIE_ASPM_ON_BAT = "powersupersave";
  #   RUNTIME_PM_ON_BAT = "auto";
  # };

  programs.steam.enable = true;
  programs.wireshark.enable = true;
  programs.adb.enable = true;
  virtualisation.waydroid.enable = true;
  programs.evolution.enable = true;
  programs.evolution.plugins = [pkgs.evolution-ews];
  services.fwupd.enable = true;

  security.pam.yubico.enable = true;
  security.pam.yubico.mode = "challenge-response";

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.max-jobs = 16;
  nix.settings.system-features = ["benchmark" "nixos-test" "big-parallel" "kvm"];

  users.users.root.password = "root";
}
