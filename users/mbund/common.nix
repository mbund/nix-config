{
  config,
  lib,
  pkgs,
  ...
}: {
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
}
