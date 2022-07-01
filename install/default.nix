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
    echo "journalctl -fb -n 100 -u install" >> ~/home/nixos/.bash_history
    
    echo "15 seconds remaining" && sleep 5
    echo "10 seconds remaining" && sleep 5
    echo " 5 seconds remaining" && sleep 5

    ${partitioner}
    nixos-install --system ${nixosSystem} --no-root-password --cores 0
    reboot
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
