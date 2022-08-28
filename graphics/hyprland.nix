{pkgs, ...}: {
  imports = [
    ../hardware/bluetooth.nix
  ];

  programs.hyprland.enable = true;

  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.jack.enable = true;
  services.pipewire.pulse.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = false;

  services.xserver.libinput.enable = true;
  services.xserver.libinput.mouse = {
    accelProfile = "flat";
    accelSpeed = "0";
    middleEmulation = false;
  };

  services.xserver.wacom.enable = true;
  programs.kdeconnect.enable = true;
  services.blueman.enable = true;
  services.flatpak.enable = true;

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.wlr.settings.screencast = {
    chooser_type = "simple";
    chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
  };

  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [dconf];
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  # allow swaylock to unlock the screen
  security.pam.services.swaylock.text = ''
    auth include login
  '';

  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  environment.persistence."/nix/state".directories = [
    "/var/lib/flatpak"
  ];
}
