{ config, lib, pkgs, ... }:
{
  imports = [
    ../hardware/bluetooth.nix
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.defaultSession = "gnome";
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.chrome-gnome-shell.enable = true;
  programs.dconf.enable = true;

  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;

  programs.evolution.enable = true;
  programs.evolution.plugins = [ pkgs.evolution-ews ];

  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  services.xserver.wacom.enable = true;
  hardware.pulseaudio.enable = lib.mkForce false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback.out ];
}
