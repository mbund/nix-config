{ nixpkgs, utils, ... }:
let

  autoInstall = system: hardwareConfiguration: partitioner:
    (nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./auto-install.nix ];
      specialArgs = {
        inherit partitioner;
        nixosSystem = (nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./auto-install-configuration.nix
            hardwareConfiguration
          ];
        }).config.system.build.toplevel;
      };
    }).config.system.build.isoImage;


  systems = with utils.lib.system; [
    x86_64-linux
    aarch64-linux
  ];

in
utils.lib.eachSystem systems (system: {
  autoinstall-hajimaru = autoInstall system
    (import ../hardware/hajimaru)
    (import ../hardware/hajimaru/partition.nix);


})
