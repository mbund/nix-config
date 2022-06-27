{ config, impermanence, lib, pkgs, ... }:
with lib;
{
  age.secrets.mbundPassword.file = ./password.age;

  users.groups.mbund.gid = config.users.users.mbund.uid;

  users.users.mbund = {
    createHome = true;
    isNormalUser = true;
    group = "mbund";
    extraGroups = [ "wheel" "dialout" ]
      ++ optionals config.hardware.i2c.enable [ "i2c" ]
      ++ optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ optionals config.virtualisation.docker.enable [ "docker" ]
      ++ optionals config.virtualisation.podman.enable [ "podman" ]
      ++ optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
      ++ optionals config.virtualisation.kvmgt.enable [ "kvm" ]
      ++ optionals config.programs.adb.enable [ "adbusers" ]
      ++ optionals config.programs.hyprland.enable [ "input" "video" "audio" ];
    openssh.authorizedKeys.keys = [

    ];
    shell = mkIf config.programs.zsh.enable pkgs.zsh;
    uid = 8888;

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
