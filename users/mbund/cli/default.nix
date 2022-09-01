{
  config,
  pkgs,
  ...
}: let
  git-sign-github = pkgs.writeShellScriptBin "git-sign-github" ''
    git config user.name mbund
    git config user.email 25110595+mbund@users.noreply.github.com
  '';
in {
  imports = [
    ./helix
  ];

  home.packages = with pkgs; [
    fortune
    cowsay
    cava
    lolcat
    cbonsai
    grc
    htop
    gnumake
    bandwhich
    bat
    bottom
    du-dust
    duf
    exa
    exiftool
    fd
    s-tui
    gdu
    zip
    unzip
    joshuto
    lazydocker
    monero-cli
    neofetch
    nix-index
    exa
    libnotify
    nix-prefetch-scripts
    nix-tree
    nix-update
    nixpkgs-review
    powertop
    ripgrep
    termshark
    git-extras
    git-lfs
    lazygit
    distrobox
    git-sign-github

    nodePackages.dockerfile-language-server-nodejs
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    nodePackages.vls
    nodePackages.svelte-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vscode-json-languageserver-bin
    ocamlPackages.ocaml-lsp
    rubyPackages.solargraph
    elmPackages.elm-language-server
    python310Packages.python-lsp-server
    clang-tools
    cmake-language-server
    dart
    deno
    elixir_ls
    gopls
    haskell-language-server
    jdt-language-server
    kotlin-language-server
    sumneko-lua-language-server
    metals
    nimlsp
    rnix-lsp
    rust-analyzer
    taplo
    zls
  ];

  programs.zellij.enable = true;
  programs.zoxide.enable = true;
  programs.atuin.enable = true;
  programs.atuin.settings.auto_sync = false;
  programs.gpg.enable = true;
  programs.gpg.homedir = "${config.home.homeDirectory}/.nix-config/.gnupg";
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "gnome3";
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";

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

  programs.git.enable = true;
  programs.git.package = pkgs.gitFull;
  programs.git.extraConfig = {
    diff = {
      colorMoved = "default";
      age.textconv = "${pkgs.rage}/bin/rage -i ~/.ssh/mbund --decrypt";
    };
    github.user = "mbund";
    init.defaultBranch = "main";
  };
  programs.git.ignores = [
    "*.swp"
    ".direnv/"
    ".envrc"
    ".vscode/"
    ".mygitignore"
  ];

  programs.fish.enable = true;
  programs.fish = {
    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "3668589799975ffd92672b5c1ecc096275375dcd";
          sha256 = "0ipwb1a5a02ms1ysfv2dc1bqa8zxcnpy4x7jsc3xk2vnyxqlc4sm";
        };
      }
      {
        name = "grc";
        inherit (pkgs.fishPlugins.grc) src;
      }
    ];

    functions = {
      fish_greeting = ""; # fortune | cowsay
      fish_command_not_found = ''
        __fish_default_command_not_found_handler $argv
      '';
    };

    shellInit = ''
      set -gx ATUIN_NOBIND "false"

      # bind to ctrl-r in normal and insert mode, add any other bindings you want here too
      bind \cr _atuin_search
      bind -M insert \cr _atuin_search
    '';

    shellAliases = {
      "nr" = "nix run";
      "unr" = "NIXPKGS_ALLOW_UNFREE=1 nix run --impure";
      "ns" = "nix shell";
      "uns" = "NIXPKGS_ALLOW_UNFREE=1 nix shell --impure";
      "nd" = "nix develop -c $SHELL";
      "und" = "NIXPKGS_ALLOW_UNFREE=1 nix develop --impure -c $SHELL";

      "ls" = "exa --binary --header --long --classify";
      "l" = "exa";
      "lg" = "lazygit";
      "j" = "joshuto";
      "code" = "codium";
    };
  };

  xdg.configFile."neofetch/config.conf".source = ./neofetch.conf;

  home.file.gdbinit = {
    target = ".gdbinit";
    text = ''
      set auto-load safe-path /
    '';
  };

  home.persistence."/nix/state/home/mbund".directories = [
    ".cache/nix-index"
    ".config/fish"
    ".local/share/fish"
    ".local/share/direnv"
    ".local/share/atuin"
    ".local/share/zoxide"
    ".config/gh"
    ".config/lazygit"
    ".kube"
    ".gnupg"
  ];

  systemd.user.startServices = "sd-switch";
  home.extraOutputsToInstall = ["doc" "devdoc"];
}
