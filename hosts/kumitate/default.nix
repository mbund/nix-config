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

  environment.etc."NetworkManager/dispatcher.d/10-tzupdate".source = pkgs.writeScript "10-tzupdate" ''
    ${pkgs.tzupdate}/bin/tzupdate -z /etc/zoneinfo -d /dev/null
  '';

  services.xserver.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.jack.enable = true;
  services.pipewire.pulse.enable = true;
  services.xserver.wacom.enable = true;
  programs.kdeconnect.enable = true;
  services.flatpak.enable = true;
  hardware.bluetooth.enable = true;

  programs.hyprland.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [dconf];
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  xdg.portal.wlr.enable = true;
  xdg.portal.wlr.settings.screencast = {
    chooser_type = "simple";
    chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
  };

  # allow swaylock to unlock the screen
  security.pam.services.swaylock.text = ''
    auth include login
  '';

  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;
  services.tlp.enable = true;
  services.tlp.settings = {
    PCIE_ASPM_ON_BAT = "powersupersave";
    RUNTIME_PM_ON_BAT = "auto";
  };

  programs.steam.enable = true;
  programs.wireshark.enable = true;
  programs.adb.enable = true;
  virtualisation.waydroid.enable = true;
  services.fwupd.enable = true;
  services.fprintd.enable = false;

  security.pam.yubico.enable = true;
  security.pam.yubico.mode = "challenge-response";

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.max-jobs = 16;
  nix.settings.system-features = ["benchmark" "nixos-test" "big-parallel" "kvm"];

  users.users.root.password = "root";
}
