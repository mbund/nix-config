{pkgs, ...}: {
  imports = [
    ./atuin.nix
    ./signature.nix
    ./zsh.nix
    ./helix
  ];

  home.packages = with pkgs; [
    bandwhich
    bat
    bottom
    du-dust
    duf
    exa
    fd
    gdu
    joshuto
    lazydocker
    monero-cli
    mosh
    ncdu
    neofetch
    nix-index
    nix-prefetch-scripts
    nix-tree
    nix-update
    nixpkgs-review
    powertop
    ripgrep
    termshark
    zellij
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | shasum | cut -d ' ' -f 1
          )}"
        }
    '';
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."neofetch/config.conf".source = ./neofetch.conf;

  home.file.gdbinit = {
    target = ".gdbinit";
    text = ''
      set auto-load safe-path /
    '';
  };

  home.extraOutputsToInstall = ["doc" "devdoc"];
}
