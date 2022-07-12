{ config, lib, host, ... }:
{
  home.sessionVariables = {
    NIX_CONFIG_DIR =
      if host == "kodai" then "$HOME/data/nix-config"
      else null;

    HOME_MANAGER_BACKUP_EXT = "hm-remove";
  };

  # remove all files ending with .hm-remove
  home.activation.removeOverwrite = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD find ${config.home.homeDirectory} -type f -name "*.hm-remove" -exec rm {} \;
  '';
}
