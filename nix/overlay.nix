{ deploy-rs
, nixpkgs
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
])
