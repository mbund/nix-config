{ pkgs, ... }: {
  xdg = {
    enable = true;
    mimeApps.enable = pkgs.stdenv.isLinux;
    userDirs = {
      enable = pkgs.stdenv.isLinux;
      desktop = "$HOME/xdg";
      documents = "$HOME/xdg";
      download = "$HOME/download";
      music = "$HOME/xdg";
      pictures = "$HOME/xdg";
      publicShare = "$HOME/xdg";
      templates = "$HOME/xdg";
      videos = "$HOME/xdg";
    };
  };
}
