{ deploy-rs
, nixpkgs
, nixpkgs-master
, ragenix
, nur
, hyprland
, ...
}:

let
  inherit (nixpkgs.lib) composeManyExtensions;
  inherit (builtins) attrNames readDir;

  localOverlays = map
    (f: import (./overlays + "/${f}"))
    (attrNames (readDir ./overlays));
in
composeManyExtensions (localOverlays ++ [
  deploy-rs.overlay
  ragenix.overlay
  nur.overlay
  hyprland.overlays.default
  (_: prev:
    let
      config = {
        inherit (prev.stdenv.hostPlatform) system;
      };

      master = import nixpkgs-master config;
    in
    {
      inherit (master) vscodium;
    }
  )
])
