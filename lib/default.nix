{ nixpkgs, ... }:
let
  colors = import ./colors.nix nixpkgs.lib;
in
colors
