{
  description = "mbund's universal nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/nur";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.flake-utils.follows = "utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        utils.follows = "utils";
      };
    };

    templates.url = "github:mbund/nix-template";
    hyprland.url = "github:hyprwm/hyprland";
  };

  outputs = { self, nixpkgs, utils, ... }@inputs: {
    deploy = import ./nix/deploy.nix inputs;

    overlays = {
      default = import ./nix/overlay.nix inputs;
      lite = import ./nix/mask-large-drvs.nix;
    };

    homeConfigurations = import ./nix/home-manager.nix inputs;

    nixosConfigurations = import ./nix/nixos.nix inputs;
  } // utils.lib.eachSystem (with utils.lib.system; [ x86_64-linux ]) (system: {
    checks = import ./nix/checks.nix inputs system;

    devShells.default = import ./nix/dev-shell.nix inputs system;

    packages = {
      default = self.packages.${system}.all;
    } // (import ./nix/host-drvs.nix inputs system);

    nixpkgs = import nixpkgs {
      inherit system;
      overlays = [
        self.overlays.default
      ];

      config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
        "steam"
        "steam-original"
        "steam-runtime"
      ];
    };
  });
}
