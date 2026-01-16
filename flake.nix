{
  description = "mbund's nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
          "steam"
          "steam-unwrapped"
        ];
    };
  in {
    nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
        ./modules/nixos/fonts.nix
        ./modules/nixos/intel.nix
        ./modules/nixos/virtualization.nix
        ./home/mbund/nixos.nix
        ./hosts/framework
      ];
    };

    homeConfigurations."mbund@framework" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = inputs;
      modules = [
        ./modules/home-manager/cli.nix
        ./modules/home-manager/fish.nix
        ./modules/home-manager/gnome-desktop.nix
        ./home/mbund
      ];
    };

    devShells.x86_64-linux.default = pkgs.mkShell {
      name = "nix-home";
      packages = with pkgs; [
        alejandra
      ];
    };

    packages.x86_64-linux = {
      framework = self.nixosConfigurations.framework.config.system.build.toplevel;
      "mbund@framework" = self.homeConfigurations."mbund@framework".activationPackage;
    };
  };
}
