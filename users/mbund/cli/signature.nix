{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # commitizen
    git-extras
    git-lfs
    lazygit
  ];

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

  programs.gpg.enable = true;
  programs.gpg.homedir = "${config.home.homeDirectory}/.nix-config/.gnupg";
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "gnome3";
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";

  programs.zsh.shellAliases = {
    "lg" = "lazygit";
    "git-sign-github" = "git config user.name mbund && git config user.email 25110595+mbund@users.noreply.github.com";
  };
}
