{
  config,
  lib,
  pkgs,
  self,
  impermanence,
  ...
}: {
  age.secrets.mbundPassword.file = ./password.age;
  users.groups.mbund.gid = config.users.users.mbund.uid;
  users.users.mbund = {
    createHome = true;
    isNormalUser = true;
    group = "mbund";
    extraGroups =
      [
        "wheel"
        "dialout"
        "users"
      ]
      ++ lib.optionals config.hardware.i2c.enable ["i2c"]
      ++ lib.optionals config.networking.networkmanager.enable ["networkmanager"]
      ++ lib.optionals config.virtualisation.docker.enable ["docker"]
      ++ lib.optionals config.virtualisation.podman.enable ["podman"]
      ++ lib.optionals config.virtualisation.libvirtd.enable ["libvirtd"]
      ++ lib.optionals config.virtualisation.kvmgt.enable ["kvm"]
      ++ lib.optionals config.programs.adb.enable ["adbusers"]
      ++ lib.optionals config.services.xserver.enable ["input" "video" "audio"]
      ++ lib.optionals config.programs.wireshark.enable ["wireshark"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2kbXZV9yOofK3s37lz5DDogOIp9EKuUxaOhVdczKDr"
    ];
    uid = 1000;
    shell = pkgs.zsh;
    passwordFile = config.age.secrets.mbundPassword.path;
  };

  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;

  home-manager.extraSpecialArgs = {
    inherit self;
    host = config.networking.hostName;
  };

  home-manager.users.mbund = {
    imports =
      [
        impermanence.home-manager.impermanence
        ./modules
        ./cli.nix
        ./common.nix
      ]
      ++ lib.optionals config.services.xserver.enable [
        ./gui.nix
        ./hyprland.nix
      ];

    home.username = config.users.users.mbund.name;
    home.uid = config.users.users.mbund.uid;
    home.stateVersion = "22.05";
  };
}
