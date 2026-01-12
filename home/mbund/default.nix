{pkgs, ...}: {
  home.packages = with pkgs; [
    s-tui
    jq
    gh
    lazygit
    helix
    zip
    unzip
    tmux

    gnome-firmware
    gnome-extension-manager
    gnome-tweaks
    dconf-editor
    wl-clipboard
    papirus-icon-theme
    adw-gtk3

    alacritty
    keepassxc
    audacity
    gimp
    gparted
    xorg.xeyes
    vscodium
    signal-desktop
  ];

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    GOPATH = "$HOME/.go";
    EDITOR = "hx";
    VISUAL = "hx";
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  home.extraOutputsToInstall = ["doc" "devdoc"];

  programs.home-manager.enable = true;

  home.homeDirectory = "/home/mbund";
  home.username = "mbund";
  home.stateVersion = "22.11";
}
