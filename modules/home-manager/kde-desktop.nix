
gnome{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    papirus-icon-theme
    wl-clipboard

    alacritty
    keepassxc
    vscodium
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };
}
