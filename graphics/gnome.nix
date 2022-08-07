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
  services.gnome.chrome-gnome-shell.enable = true;
  programs.dconf.enable = true;

  virtualisation.waydroid.enable = true;
  virtualisation.lxd.enable = true;

  services.power-profiles-daemon.enable = false;

  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;

  programs.evolution.enable = true;
  programs.evolution.plugins = [pkgs.evolution-ews];

  services.flatpak.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  services.xserver.wacom.enable = true;
  hardware.pulseaudio.enable = lib.mkForce false;
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
    "/var/lib/waydroid"
    "/var/lib/flatpak"
  ];
}
