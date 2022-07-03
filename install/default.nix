{ self, nixpkgs, ... }:

system:

let

  pkgs = self.pkgs.${system};

  genNixosSystem = hardwareConfigurationFile: (nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      (import hardwareConfigurationFile)
      ./configuration.nix
    ];
  }).config.system.build.toplevel;

  genInstallScript = nixosSystem: partitioner: pkgs.writeShellScriptBin "install" ''
    ${partitioner} "$@"
    nixos-install --system ${nixosSystem} --no-root-password --cores 0
  '';

  genAutoInstallIso = installScript:
    (nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./auto-install-iso.nix ];
      specialArgs = { inherit installScript; };
    }).config.system.build.isoImage;
in
rec {
  hajimaru-install = genInstallScript (genNixosSystem ../hardware/hajimaru) (builtins.readFile ../hardware/hajimaru/partition.sh);
  hajimaru-autoinstall-iso = genAutoInstallIso hajimaru-install;
}
