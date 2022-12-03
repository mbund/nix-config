inputs: let
  inherit (inputs.nixpkgs.lib) composeManyExtensions;
  inherit (builtins) attrNames readDir;

  localOverlays =
    map
    (f: import (./overlays + "/${f}"))
    (attrNames (readDir ./overlays));
in
  with inputs;
    composeManyExtensions (localOverlays
      ++ [
        deploy-rs.overlay
        ragenix.overlays.default
        nur.overlay
        hyprland.overlays.default
        devshell.overlay
        (
          _: prev: let
            config = {
              inherit (prev.stdenv.hostPlatform) system;
            };

            master = import nixpkgs-master config;
            wpa = import nixpkgs-wpa config;
          in {
            inherit (master) vscodium;
            inherit (wpa) wpa_supplicant;
          }
        )
      ])
