{pkgs, ...}: {
  home.packages = with pkgs; [
    amberol
    blanket
    celluloid
    fragments
    gnome-firmware
    gnome-extension-manager
    blackbox-terminal

    wl-clipboard
    libgda
    gsound
    gnomeExtensions.pano

    papirus-icon-theme
    adw-gtk3
    adwaita-qt

    gnome.gnome-power-manager
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.gnome-boxes
  ];
}
