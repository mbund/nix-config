{pkgs, ...}: {
  imports = [
    ./cli.nix
    ./gui.nix
    ./gnome.nix
  ];

  xdg.enable = true;
  xdg.userDirs = {
    enable = pkgs.stdenv.isLinux;
    pictures = "$HOME/data/pictures";
    videos = "$HOME/data/videos";
    music = "$HOME/data/music";
    publicShare = "$HOME/data/public";
    templates = "$HOME/data/templates";
    desktop = "$HOME/data/desktop";
    documents = "$HOME/data/documents";
    download = "$HOME/download";
  };

  # for fish manually add `set -gx GOPATH $HOME/.go` in `~/.config/fish/config.fish`
  home.sessionVariables = {
    GOPATH = "$HOME/.go";
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.home-manager.enable = true;

  home.homeDirectory = "/home/mbund";
  home.username = "mbund";
  home.stateVersion = "22.05";
}
