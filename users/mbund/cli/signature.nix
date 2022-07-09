{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    commitizen
    git-extras
    git-lfs
    lazygit
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    extraConfig = {
      diff = {
        colorMoved = "default";
        age.textconv = "${pkgs.rage}/bin/rage -i ~/.ssh/mbund --decrypt";
      };
      github.user = "mbund";
      init.defaultBranch = "main";
    };
    ignores = [
      "*.swp"
      ".direnv/"
      ".envrc"
      ".vscode/"
      ".mygitignore"
    ];
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.nix-config/.gnupg";
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.zsh.shellAliases = {
    "lg" = "lazygit";
    "git-sign-github" = "git config user.name mbund && git config user.email 25110595+mbund@users.noreply.github.com && git config user.signingkey 6C8949C0713C5B3C";
  };

  home.persistence."/state/home/mbund".directories = [
    ".ssh"
    ".gnupg"
  ];
}
