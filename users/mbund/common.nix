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

  home.file.".hm-env".text = let
    export = n: v: ''export ${n}="${toString v}"'';
    exportAll = vars: lib.concatStringsSep "\n" (lib.mapAttrsToList export vars);
  in ''
    # modules/programs/zsh.nix

    if [[ -z "$__HM_ZSH_SESS_VARS_SOURCED" ]]; then
      export __HM_ZSH_SESS_VARS_SOURCED=1
      ${exportAll config.home.sessionVariables}
    fi
  '';
}
