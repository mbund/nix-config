{ pkgs, ... }: {
  home.packages = with pkgs; [
    nix-index
    exa
    libnotify
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
        name = "auto-notify";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-auto-notify";
          rev = "1f64cb654473d7208f46534bc3df47ac919d4a72";
          sha256 = "0x93mb72jkzn90qmy07vxj3vhvm14bx4sncnclh7yq545x0b1zg3";
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

      "code" = "codium";
    };

    initExtraBeforeCompInit = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';

    initExtra = ''
      # configure auto-notify
      export AUTO_NOTIFY_THRESHOLD=60
      export AUTO_NOTIFY_IGNORE=("man" "docker" "hx" "lazygit" "lazydocker")
      export AUTO_NOTIFY_EXPIRE_TIME=4000
      export AUTO_NOTIFY_TITLE="\"%command\" completed [%exit_code]"
      export AUTO_NOTIFY_BODY="in %elapsed seconds"

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
}
