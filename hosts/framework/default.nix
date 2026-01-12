# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  time.timeZone = "America/New_York";

  networking.hostName = "framework";
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
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

  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.avahi.nssmdns4 = true;
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    hplip
  ];

  programs.fish.enable = true;
  environment.pathsToLink = ["/share/fish"];

  programs.steam.enable = true;
  programs.wireshark.enable = true;
  programs.firefox.enable = true;
  services.tailscale.enable = true;
  services.fwupd.enable = true;
  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    android-tools
  ];

  nix = {
    extraOptions = ''
      builders-use-substitutes = true
      experimental-features = nix-command flakes recursive-nix
    '';
  };

  system.stateVersion = "25.11";
}
