{ pkgs, colors, ... }:
let
  inherit (colors) xcolors;
in
{
  imports = [
    ./firefox.nix
    ./wayland.nix
    ./terminals.nix
    ./media.nix
  ];

  home.packages = with pkgs; [
    ferdium
    xorg.xeyes
  ];

  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      recolor-darkcolor = "#${xcolors.base00}";
      recolor-lightcolor = "rgba(0,0,0,0)";
      default-bg = "rgba(0,0,0,0.7)";
      default-fg = "#${xcolors.base06}";
    };
  };

  home.file.".config" = {
    source = ./config;
    recursive = true;
  };

}
