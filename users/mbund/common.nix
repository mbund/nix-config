{
  config,
  lib,
  pkgs,
  host,
  ...
}: {
  xdg.enable = true;
  xdg.mimeApps.enable = pkgs.stdenv.isLinux;
  # xdg.cacheHome = "${config.home.homeDirectory}/.nix-config/.cache";
  # xdg.configHome = "${config.home.homeDirectory}/.nix-config/.config";
  # xdg.dataHome = "${config.home.homeDirectory}/.nix-config/.local/share";
  # xdg.stateHome = "${config.home.homeDirectory}/.nix-config/.local/state";
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

  # force overwrite all collisions with home-manager's files
  home.activation.setBackupExtension = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    export HOME_MANAGER_BACKUP_EXT=hm-remove
  '';

  home.activation.removeOverwrite = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD find ${config.home.homeDirectory} -type f -name "*.hm-remove" -exec rm {} \;
  '';

  home.persistence."/nix/state/home/mbund".allowOther = true;
  home.persistence."/nix/state/home/mbund".directories = [
    "data"
    "xdg"
  ];
}
