{pkgs, ...}: {
  home.packages = with pkgs; [
    # utilities
    fortune
    bear
    gnupg
    ngrok
    cowsay
    cava
    kubectl
    kubernetes-helm
    fluxcd
    terraform
    sqlite
    lolcat
    cbonsai
    grc
    htop
    gnumake
    bandwhich
    file
    exiftool
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
    libnotify
    nix-prefetch-scripts
    nix-tree
    nix-update
    nixpkgs-review
    powertop
    termshark
    git-extras
    git-lfs
    lazygit
    distrobox
    atuin
    direnv
    nmap
    dnsutils
    just
    powershell

    # modern unix
    helix
    zellij
    bat
    bottom
    du-dust
    duf
    exa
    ripgrep
    fd
    broot
    delta
    gping
    procs
    hyperfine
    httpie
    curlie
    xh
    zoxide
    sd
    jq
    fzf
    tldr

    # lsp
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
    clang-tools
    cmake-language-server
    dart
    elixir_ls
    gopls
    haskell-language-server
    jdt-language-server
    kotlin-language-server
    sumneko-lua-language-server
    terraform-ls
    metals
    nimlsp
    rnix-lsp
    alejandra
    rust-analyzer
    taplo

    # dev toolchains
    zig
    nim
    go
    zls
    bun
    deno
    yarn
    nodejs-18_x
    nodePackages_latest.pnpm
    rustup
    python312
    clang
  ];

  systemd.user.startServices = "sd-switch";
  home.extraOutputsToInstall = ["doc" "devdoc"];
}
