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
        devshell.overlays.default
        (
          _: prev: let
            config = {
              inherit (prev.stdenv.hostPlatform) system;
              config.allowUnfreePredicate = pkg:
                builtins.elem (nixpkgs.lib.getName pkg) [
                  "discord"
                  "vscode"
                ];
            };

            master = import nixpkgs-master config;
            wpa = import nixpkgs-wpa config;
          in {
            inherit (master) vscode vscodium discord;
            inherit (wpa) wpa_supplicant;
          }
        )
      ])
