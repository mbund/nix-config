{pkgs, ...}: {
  home.packages = with pkgs; [
    alacritty
    audacity
    gimp
    gparted
    keepassxc
    libreoffice
    signal-desktop
    vscodium
    xorg.xeyes
  ];

  home.sessionVariables = {
    GOPATH = "$HOME/.go";
    EDITOR = "hx";
    VISUAL = "hx";
  };

  home.extraOutputsToInstall = ["doc" "devdoc"];

  programs.home-manager.enable = true;

  home.homeDirectory = "/home/mbund";
  home.username = "mbund";
  home.stateVersion = "22.11";
}
