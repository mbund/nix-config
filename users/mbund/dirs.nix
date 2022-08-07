{pkgs, ...}: {
  xdg = {
    enable = true;
    mimeApps.enable = pkgs.stdenv.isLinux;
    # cacheHome = "${config.home.homeDirectory}/.nix-config/.cache";
    # configHome = "${config.home.homeDirectory}/.nix-config/.config";
    # dataHome = "${config.home.homeDirectory}/.nix-config/.local/share";
    # stateHome = "${config.home.homeDirectory}/.nix-config/.local/state";
    userDirs = {
      enable = pkgs.stdenv.isLinux;
      pictures = "$HOME/data/pictures";
      videos = "$HOME/data/videos";
      download = "$HOME/download";
      desktop = "$HOME/xdg";
      documents = "$HOME/xdg";
      music = "$HOME/xdg";
      publicShare = "$HOME/xdg";
      templates = "$HOME/xdg";
    };
  };
}
