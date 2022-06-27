{ pkgs, ... }: {
  imports = [
    ./atuin.nix
    ./bash.nix
    ./btop.nix
    ./git.nix
    ./htop.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home = {
    username = "mbund";
    stateVersion = "22.05";
    packages = with pkgs; [
      bandwhich
      exa
      fd
      kalker
      mosh
      neofetch
      ripgrep
      nix-tree
      nix-index
      nix-prefetch-scripts
    ];
  };

  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.gpg.enable = true;

  systemd.user.startServices = "sd-switch";
}
