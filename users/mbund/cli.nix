{pkgs, ...}: {
  home.packages = with pkgs; [
    fortune
    bear
    gnupg
    ngrok
    helix
    cowsay
    cava
    kubectl
    lolcat
    cbonsai
    grc
    htop
    gnumake
    bandwhich
    bat
    bottom
    du-dust
    file
    duf
    exiftool
    fd
    s-tui
    gh
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
    zellij
    zoxide
    atuin
    direnv
    # xxh
    nmap
    dnsutils

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
    python310Packages.autopep8
    black
    nim
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
    alejandra
    rust-analyzer
    rustfmt
    taplo
    zig
    zls
  ];

  systemd.user.startServices = "sd-switch";
  home.extraOutputsToInstall = ["doc" "devdoc"];
}
