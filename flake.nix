{
  description = "mbund's nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nur.url = "github:nix-community/nur";
    devshell.url = "github:numtide/devshell";
    agenix.url = "github:yaxitech/ragenix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-analyzer.url = "github:jm8/nix-analyzer";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config.allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "davinci-resolve"
          "discord"
          "minecraft-launcher"
          "nvidia-persistenced"
          "nvidia-settings"
          "nvidia-x11"
          "steam-original"
          "steam-runtime"
          "steam"
          "steam-run"
          "zoom"
          "ngrok"
        ];
    };
  in {
    nixosConfigurations.kumitate = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
        inputs.home-manager.nixosModules.default
        inputs.agenix.nixosModules.default
        ./hosts/kumitate
        ./hosts/kumitate/hardware-configuration.nix
        ./modules/fonts.nix
        ./modules/intel.nix
        ./modules/networking.nix
        ./modules/nix.nix
        ./modules/virtualisation.nix
        ./users/mbund/nixos.nix
      ];
    };

    homeConfigurations."mbund@kumitate" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = inputs;
      modules = [
        ./users/mbund/home.nix
      ];
    };

    packages.x86_64-linux = {
      kumitate = self.nixosConfigurations.kumitate.config.system.build.toplevel;
      "mbund@kumitate" = self.homeConfigurations."mbund@kumitate".activationPackage;
    };
  };
}
