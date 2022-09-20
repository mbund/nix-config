{pkgs, ...}: {
  home.packages = with pkgs; [
    amberol
    blanket
    celluloid
    fragments

    gnome.gnome-power-manager
    gnome.dconf-editor
    gnome.gnome-tweaks

    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.caffeine
    gnomeExtensions.appindicator
    gnomeExtensions.tiling-assistant
  ];
}
