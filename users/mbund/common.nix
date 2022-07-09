{ host, ... }:
{
  home.sessionVariables = {
    NIX_CONFIG_DIR =
      if host == "kodai" then "$HOME/data/nix-config"
      else null;
  };

  home.persistence."/state/home/mbund".allowOther = false;
}
