{pkgs, ...}: let
  dummyConfig = pkgs.writeText "configuration.nix" ''
    assert builtins.trace "This is a dummy config, use deploy-rs!" false;
    { }
  '';
in {
  environment.etc."nixos/configuration.nix".source = dummyConfig;

  # required superuser configuration for deploy-rs
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;
  security.doas.enable = true;
  security.doas.wheelNeedsPassword = false;

  # speed up nix builds
  boot.tmpOnTmpfs = true;

  nix = {
    nixPath = [
      "nixos-config=${dummyConfig}"
      "nixpkgs=/run/current-system/nixpkgs"
      "nixpkgs-overlays=/run/current-system/overlays"
    ];

    settings = {
      allowed-users = ["*"];
      trusted-users = ["root" "@wheel"];
      system-features = ["recursive-nix"];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 5;
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
      experimental-features = nix-command flakes recursive-nix
      flake-registry = /etc/nix/registry.json
    '';
    optimise = {
      automatic = true;
      dates = ["03:00"];
    };
  };

  system = {
    extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
      ln -sv ${../nix/overlays} $out/overlays

      # Copy over full nixos-config to `/var/run/current-system/full-config/`
      # (available to the currently active derivation for safety/debugging)
      cp -rf ${../.} $out/full-config
    '';

    stateVersion = "22.05";
  };
}
