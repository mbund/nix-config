{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../hardware/bluetooth.nix
    ../hardware/printing.nix
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.defaultSession = "gnome";
  services.xserver.desktopManager.gnome.enable = true;

  # disable what gnome enables by default
  services.avahi.enable = false;
  services.power-profiles-daemon.enable = false;
  hardware.pulseaudio.enable = lib.mkForce false;

  # misc
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };
  programs.evolution = {
    enable = true;
    plugins = [pkgs.evolution-ews];
  };
  services.gnome.chrome-gnome-shell.enable = true;
  services.flatpak.enable = true;
  services.xserver.wacom.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  services.pipewire.enable = true;
  services.pipewire.alsa = {
    enable = true;
    support32Bit = true;
  };
  services.pipewire.pulse.enable = true;
  services.pipewire.jack.enable = true;
  boot.kernelModules = ["v4l2loopback"];
  boot.extraModulePackages = [config.boot.kernelPackages.v4l2loopback.out];

  environment.persistence."/state".directories = [
    "/var/lib/flatpak"
  ];
}
