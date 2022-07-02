{ config, lib, pkgs, impermanence, ... }:
with lib;
{
  age.secrets.mbundPassword.file = ./password.age;
  users.groups.mbund.gid = config.users.users.mbund.uid;
  users.users.mbund = {
    createHome = true;
    isNormalUser = true;
    group = "mbund";
    extraGroups = [ "wheel" "dialout" "users" ]
      ++ optionals config.hardware.i2c.enable [ "i2c" ]
      ++ optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ optionals config.virtualisation.docker.enable [ "docker" ]
      ++ optionals config.virtualisation.podman.enable [ "podman" ]
      ++ optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
      ++ optionals config.virtualisation.kvmgt.enable [ "kvm" ]
      ++ optionals config.programs.adb.enable [ "adbusers" ]
      ++ optionals config.programs.hyprland.enable [ "input" "video" "audio" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2kbXZV9yOofK3s37lz5DDogOIp9EKuUxaOhVdczKDr"
    ];
    shell = mkIf config.programs.zsh.enable pkgs.zsh;
    uid = 1000;

    passwordFile = config.age.secrets.mbundPassword.path;
  };

  home-manager.users.mbund = {
    imports = [
      impermanence.home-manager.impermanence
      ./core
      ./dev
      ./modules
    ] ++ optionals config.programs.hyprland.enable [
      ./graphics
      ./graphics/hyprland
    ];

    home.username = config.users.users.mbund.name;
    home.uid = config.users.users.mbund.uid;
  };
}
