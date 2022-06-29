{ nixpkgs, ... }:
let

  autoInstall = system: install:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    (nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        install = install { inherit pkgs; };
        inherit system nixpkgs;
      };
      modules = [ ./auto-install.nix ];
    }).config.system.build.isoImage;

in
{
  autoinstall-hajimaru-x86_64 = autoInstall "x86_64-linux" (import ../hardware/hajimaru/install.nix);
}
