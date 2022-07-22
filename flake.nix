{
  description = "mbund's universal nix configuration";

  outputs = { self, nixpkgs, utils, ... }@inputs: {
    deploy = import ./nix/deploy.nix inputs;

    overlays.default = import ./nix/overlay.nix inputs;

    homeConfigurations = import ./nix/home-manager.nix inputs;

    lib = import ./lib inputs;

    nixosConfigurations = import ./nix/nixos.nix inputs;
  } // utils.lib.eachSystem (with utils.lib.system; [ x86_64-linux aarch64-linux ]) (system: {
    checks = import ./nix/checks.nix inputs system;

    devShells.default = import ./nix/dev-shell.nix inputs system;

    packages = {
      default = self.packages.${system}.all;
    } // (import ./nix/host-drvs.nix inputs system)
    // (import ./install inputs system);

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        self.overlays.default
      ];

      config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
        "davinci-resolve"
        "minecraft-launcher"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
        "steam-original"
        "steam-runtime"
        "steam"
      ];
    };
  });

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

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

    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-helix = {
      url = "github:catppuccin/helix";
      flake = false;
    };

    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    templates.url = "github:mbund/nix-template";

    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.naersk.follows = "naersk";
    };

    nix-colors.url = "github:Misterio77/nix-colors";
  };
}
