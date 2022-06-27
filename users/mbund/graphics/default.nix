{ pkgs, ... }: {
  imports = [
    ./firefox.nix

    ./hyprland
  ];

  home.packages = with pkgs; [
    zathura
    xorg.xeyes
  ];

}
