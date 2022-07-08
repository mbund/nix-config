{ self, ragenix, impermanence, nixpkgs, ... }:

system:

let

  pkgs = self.pkgs.${system};

  genNixosSystem = hardwareConfigurationFile: (nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      (import hardwareConfigurationFile)
      ./configuration.nix
      ragenix.nixosModules.age
      impermanence.nixosModules.impermanence
    ];
  }).config.system.build.toplevel;

  genAutoInstallIso = installScript:
    (nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./auto-install-iso.nix ];
      specialArgs = { inherit installScript; };
    }).config.system.build.isoImage;
in
rec {
  hajimaru-installer = pkgs.writeShellScriptBin "install" ''
    set -e
    ${../hardware/hajimaru/partition.sh} "$@"
    nixos-install --system ${genNixosSystem ../hardware/hajimaru} --no-channel-copy --no-root-password --cores 0
  '';

  hajimaru-autoinstall-iso = genAutoInstallIso hajimaru-installer;
}
