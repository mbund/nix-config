inputs:

let
  inherit (inputs.nixpkgs.lib) composeManyExtensions;
  inherit (builtins) attrNames readDir;

  localOverlays = map
    (f: import (./overlays + "/${f}"))
    (attrNames (readDir ./overlays));
in
with inputs;
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
