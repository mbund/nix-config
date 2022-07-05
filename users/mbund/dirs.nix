{ config, pkgs, ... }: {
  xdg = {
    enable = true;
    mimeApps.enable = pkgs.stdenv.isLinux;
    cacheHome = "${config.home.homeDirectory}/.nix-config/.cache";
    configHome = "${config.home.homeDirectory}/.nix-config/.config";
    dataHome = "${config.home.homeDirectory}/.nix-config/.local/share";
    stateHome = "${config.home.homeDirectory}/.nix-config/.local/state";
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
