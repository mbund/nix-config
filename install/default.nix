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

    mkdir -p /mnt/etc/nixos
    install -D ${./configuration.nix} /mnt/etc/nixos/a.nix
    install -D ${../hardware/hajimaru/default.nix} /mnt/etc/nixos/b.nix
    cat > /mnt/etc/nixos/configuration.nix << EOL
    {
      imports = [ ./a.nix ./b.nix ];
    }
    EOL

    nixos-install --no-root-password --cores 0
  '';

  hajimaru-autoinstall-iso = genAutoInstallIso (pkgs.writeShellScriptBin "install" ''
    set -e
    ${../hardware/hajimaru/partition.sh} "$@"
    nixos-install --system ${genNixosSystem ../hardware/hajimaru} --no-root-password --cores 0
  '');
}
