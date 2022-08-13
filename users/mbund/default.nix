{
  config,
  lib,
  pkgs,
  self,
  impermanence,
  ...
}:
with lib; let
  theme = "onedark";

  colors = with self.lib; rec {
    baseColors = self.inputs.nix-colors.colorSchemes.${theme}.colors;
    # normal hex values
    xcolors = mapAttrs (_: x) baseColors;
    # rgba hex values
    xrgbaColors = mapAttrs (_: xrgba) baseColors;
    # argb hex values
    xargbColors = mapAttrs (_: xargb) baseColors;
    # 0xABCDEF colors (alacritty)
    x0Colors = mapAttrs (_: x0) baseColors;
    # rgba(,,,) colors (css)
    rgbaColors = mapAttrs (_: rgba) baseColors;
  };
in {
  age.secrets.mbundPassword.file = ./password.age;
  users.groups.mbund.gid = config.users.users.mbund.uid;
  users.users.mbund = {
    createHome = true;
    isNormalUser = true;
    group = "mbund";
    extraGroups =
      ["wheel" "dialout" "users"]
      ++ optionals config.hardware.i2c.enable ["i2c"]
      ++ optionals config.networking.networkmanager.enable ["networkmanager"]
      ++ optionals config.virtualisation.docker.enable ["docker"]
      ++ optionals config.virtualisation.podman.enable ["podman"]
      ++ optionals config.virtualisation.libvirtd.enable ["libvirtd"]
      ++ optionals config.virtualisation.kvmgt.enable ["kvm"]
      ++ optionals config.programs.adb.enable ["adbusers"]
      ++ optionals config.services.xserver.enable ["input" "video" "audio"]
      ++ optionals config.programs.wireshark.enable ["wireshark"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2kbXZV9yOofK3s37lz5DDogOIp9EKuUxaOhVdczKDr"
    ];
    shell = pkgs.zsh;
    uid = 1000;

    passwordFile = config.age.secrets.mbundPassword.path;
  };

  programs.zsh.enable = true;

  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "mbund";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;

  home-manager.extraSpecialArgs = {
    inherit colors self;
    host = config.networking.hostName;
  };

  home-manager.users.mbund = {
    imports =
      [
        impermanence.home-manager.impermanence
        ./cli
        ./modules
        ./common.nix
      ]
      ++ optionals config.services.xserver.enable [
        ./gui.nix
        ./gnome.nix
      ];

    home.username = config.users.users.mbund.name;
    home.uid = config.users.users.mbund.uid;
    home.stateVersion = "22.05";
  };
}
