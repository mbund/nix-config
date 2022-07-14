{ self, ragenix, impermanence, nixpkgs, ... }:

system:

let

  pkgs = self.pkgs.${system};

  genNixosSystem = extraConfiguration: (nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ./configuration.nix
      extraConfiguration
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
    nixos-install --system ${genNixosSystem (import ../hardware/hajimaru)} --no-channel-copy --no-root-password --cores 0
  '';

  hajimaru-autoinstall-iso = genAutoInstallIso hajimaru-installer;

  lkube-installer = pkgs.writeShellScriptBin "install" ''
    nixos-install --system ${genNixosSystem (import ../hosts/lkube1)} --no-channel-copy --no-root-password --cores 0
  '';

  lkube-autoinstall-iso = genAutoInstallIso lkube-installer;
}
