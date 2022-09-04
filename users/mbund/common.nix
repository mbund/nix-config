{pkgs, ...}: {
  xdg.enable = true;
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "zathura.desktop";
    "inode/directory" = "dolphin.desktop";
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/chrome" = "firefox.desktop";
    "application/x-extension-htm" = "firefox.desktop";
    "application/x-extension-html" = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/x-extension-xht" = "firefox.desktop";
  };
  xdg.userDirs = {
    enable = pkgs.stdenv.isLinux;
    pictures = "$HOME/data/pictures";
    videos = "$HOME/data/videos";
    music = "$HOME/data/music";
    publicShare = "$HOME/data/public";
    templates = "$HOME/data/templates";
    desktop = "$HOME/data";
    documents = "$HOME/data";
    download = "$HOME/download";
  };

  home.persistence."/nix/state/home/mbund" = {
    allowOther = true;
    directories = [
      "data"
      "school"
      "dev"

      ".config/git"
      ".local/share/keyrings"
      ".local/share/flatpak"
      ".var/app"
      ".yubico"
      ".ssh"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
  };
}
