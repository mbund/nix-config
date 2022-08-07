{
  self,
  ragenix,
  impermanence,
  nixpkgs,
  ...
}: system: let
  pkgs = self.pkgs.${system};

  genNixosSystem = modules:
    (nixpkgs.lib.nixosSystem {
      inherit system modules;
    })
    .config
    .system
    .build
    .toplevel;

  genAutoInstallIso = installScript:
    (nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [./auto-install-iso.nix];
      specialArgs = {inherit installScript;};
    })
    .config
    .system
    .build
    .isoImage;
in rec {
  hajimaru-installer = pkgs.writeShellScriptBin "install" ''
    set -e
    ${../hardware/hajimaru/partition.sh} "$@"
    nixos-install --system ${genNixosSystem [
      ./configuration.nix
      ../hardware/hajimaru
      ragenix.nixosModules.age
      impermanence.nixosModules.impermanence
    ]} --no-channel-copy --no-root-password --cores 0
  '';

  hajimaru-autoinstall-iso = genAutoInstallIso hajimaru-installer;

  linode-installer = pkgs.writeShellScriptBin "install" ''
    nixos-install --system ${genNixosSystem [
      ./configuration.nix
      ../hardware/linode.nix
    ]} --no-channel-copy --no-root-password --cores 0
  '';

  linode-autoinstall-iso = genAutoInstallIso linode-installer;
}
