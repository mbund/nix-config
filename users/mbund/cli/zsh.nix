{ pkgs, ... }: {
  home.packages = with pkgs; [
    nix-index
    exa
  ];

  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    plugins = [
      {
        name = "you-should-use";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "2be37f376c13187c445ae9534550a8a5810d4361";
          sha256 = "0yhwn6av4q6hz9s34h4m3vdk64ly6s28xfd8ijgdbzic8qawj5p1";
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
      "la" = "ls --all";
      "l" = "ls";
    };

    initExtraBeforeCompInit = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';

    initExtra = ''
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

      # send notifications on ending long running commands
      cmdignore=(htop tmux top vim)

      # end and compare timer, notify-send if needed
      function notifyosd-precmd() {
        retval=$?
        if [ ! -z "$cmd" ]; then
          cmd_end=`date +%s`
          ((cmd_time=$cmd_end - $cmd_start))
        fi
        if [ $retval -eq 0 ]; then
          cmdstat="✓"
        else
          cmdstat="✘"
        fi
        if [ ! -z "$cmd" ] && [[ $cmd_time -gt 3 ]]; then
          ${pkgs.libnotify}/bin/notify-send -a command_complete -i utilities-terminal -u low "$cmdstat $cmd" "in `date -u -d @$cmd_time +'%T'`"
          echo -e '\a'
        fi
        unset cmd
      }

      # make sure this plays nicely with any existing precmd
      precmd_functions+=( notifyosd-precmd )

      # get command name and start the timer
      function notifyosd-preexec() {
        cmd=$1
        cmd_start=`date +%s`
      }
    '';
  };
}
