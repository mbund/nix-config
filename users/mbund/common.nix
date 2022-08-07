{
  config,
  lib,
  host,
  ...
}: {
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
}
