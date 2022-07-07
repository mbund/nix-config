{ self
, nur
, home-manager
, impermanence
, nixos-hardware
, nixpkgs
, ragenix
, templates
, ...
}:
let
  inherit (nixpkgs) lib;
  hosts = (import ./hosts.nix).nixos.all;

  netHostMap = {
    networking.hosts = lib.mapAttrs' (n: v: lib.nameValuePair v.address [ n ]) hosts;
  };

  nixRegistry = {
    nix.registry = {
      templates.flake = templates;
      nixpkgs.flake = nixpkgs;
      np.flake = nixpkgs;
    };
  };

  hostPkgs = localSystem: {
    nixpkgs = {
      localSystem.system = localSystem;
      pkgs = self.pkgs.${localSystem};
    };
  };

  genConfiguration = hostname: { localSystem, ... }:
    lib.nixosSystem {
      system = localSystem;
      modules = [
        (../hosts + "/${hostname}")
        (hostPkgs localSystem)
        nixRegistry
        netHostMap
        nur.nixosModules.nur
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        ragenix.nixosModules.age
      ];
      specialArgs = {
        inherit self;
        impermanence = impermanence.nixosModules;
        nixos-hardware = nixos-hardware.nixosModules;
      };
    };
in
lib.mapAttrs genConfiguration hosts
