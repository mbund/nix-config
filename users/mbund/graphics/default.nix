{ pkgs, ... }: {
  imports = [
    ./firefox.nix

    ./hyprland
  ];

  home.packages = with pkgs; [
    ferdium
    zathura
    xorg.xeyes
  ];

}
