{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    bottom
    gh
    helix
    jq
    lazygit
    s-tui
    tmux
    unzip
    zip
  ];

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
}
