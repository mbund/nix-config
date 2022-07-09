{ pkgs, ... }: {
  imports = [
    ./atuin.nix
    ./signature.nix
    ./zsh.nix
    ./helix
  ];

  home.packages = with pkgs; [
    fd
    bat
    duf
    exa
    mosh
    bottom
    du-dust
    ripgrep
    joshuto
    bandwhich
    neofetch
    nix-tree
    nix-index
    nix-update
    lazydocker
    nixpkgs-review
    nix-prefetch-scripts
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

  home.file.gdbinit = {
    target = ".gdbinit";
    text = ''
      set auto-load safe-path /
    '';
  };

  home.extraOutputsToInstall = [ "doc" "devdoc" ];

  home.persistence."/state/home/mbund".directories = [
    ".cache/nix-index"
    ".cache/zsh"
    ".local/share/direnv"
    ".local/share/zsh"
  ];
}
