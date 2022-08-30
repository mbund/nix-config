{
  pkgs,
  host,
  ...
}: {
  xdg.enable = true;
  xdg.userDirs = {
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

  home.sessionVariables = {
    NIX_CONFIG_DIR =
      if host == "kodai"
      then "$HOME/data/nix-config"
      else null;
  };

  home.persistence."/nix/state/home/mbund" = {
    allowOther = true;
    directories = [
      # ".local/share/keyrings"
      ".yubico"
      ".ssh"
      "data"
      "xdg"
    ];
    files = [
      ".config/mimeapps.list"
    ];
  };
}
