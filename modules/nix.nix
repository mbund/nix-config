{
  pkgs,
  nixpkgs,
  nur,
  ...
}: let
  dummyConfig = pkgs.writeText "configuration.nix" ''
    assert builtins.trace "Use the custom flake instead!" false;
    { }
  '';
in {
  environment.etc."nixos/configuration.nix".source = dummyConfig;

  environment.systemPackages = with pkgs; [
    git
    vim
    helix
    wget
    curl
  ];

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  boot.tmp.useTmpfs = true;

  nix = {
    nixPath = [
      "nixos-config=${dummyConfig}"
      "nixpkgs=/run/current-system/nixpkgs"
      "nixpkgs-overlays=/run/current-system/overlays"
    ];

    registry = {
      nixpkgs.flake = nixpkgs;
      np.flake = nixpkgs;
      nur.flake = nur;
    };

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

      # Copy over full nixos-config to `/var/run/current-system/full-config/`
      # (available to the currently active derivation for safety/debugging)
      cp -rf ${../.} $out/full-config
    '';

    stateVersion = "22.05";
  };
}
