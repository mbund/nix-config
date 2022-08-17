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
    git-sign-github
    # commitizen
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

  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    plugins = [
      {
        name = "you-should-use";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "09d9aa2cad2b7caf48cce8f321ebbbf8f47ce1c3";
          sha256 = "07iqlry4mim5cqi8x5vi64dvwqqp298jbaz3ycks9rxsqlczzlnl";
        };
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    shellGlobalAliases = {
      "UUID" = "$(uuidgen | tr -d \\n)";
    };

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

      "code" = "codium";
    };

    initExtraBeforeCompInit = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';

    envExtra = ''
      export ATUIN_NOBIND="true"
    '';

    initExtra = ''
      bindkey '^r' _atuin_search_widget

      # create custom command not found handler by searching through nix-index for it
      command_not_found_handle() {
        # taken from http://www.linuxjournal.com/content/bash-command-not-found
        # - do not run when inside Midnight Commander or within a Pipe
        if [ -n "''${MC_SID-}" ] || ! [ -t 1 ]; then
          >&2 echo "$1: command not found"
          return 127
        fi
        cmd=$1
        attrs=$(${pkgs.nix-index}/bin/nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$cmd")
        len=$(echo -n "$attrs" | grep -c "^")
        case $len in
          0)
            >&2 echo "$cmd: command not found in nixpkgs (run nix-index to update the index)"
            ;;
          *)
            >&2 echo "$cmd was found in the following derivations:\n"
            while read attr; do
              >&2 echo "nixpkgs#$attr"
            done <<< "$attrs"
            ;;
        esac
        return 127 # command not found should always exit with 127
      }

      command_not_found_handler() {
        command_not_found_handle $@
        return $?
      }
    '';
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
    ".cache/zsh"
    ".local/share/zsh"
    ".local/share/direnv"
    ".local/share/atuin"
    ".config/gh"
    ".config/lazygit"
    ".gnupg"
  ];

  systemd.user.startServices = "sd-switch";
  home.extraOutputsToInstall = ["doc" "devdoc"];
}
