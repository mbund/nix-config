{...}: {
  imports = [
    ./common.nix
    ./cli.nix
    ./gui.nix
    ./gnome.nix
  ];

  programs.home-manager.enable = true;

  home.homeDirectory = "/home/mbund";
  home.username = "mbund";
  home.stateVersion = "22.05";
}
