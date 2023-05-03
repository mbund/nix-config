{pkgs, ...}: {
  home.packages = with pkgs; [
    wl-clipboard

    clinfo
    glxinfo
    vulkan-tools
    pciutils

    papirus-icon-theme
  ];
}
