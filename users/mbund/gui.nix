{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ferdium
    xorg.xeyes
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
  };

  programs.obs-studio.enable = true;

  home.persistence."/state/home/mbund".directories = [
    ".config/Ferdium"
    ".config/VSCodium"
    ".config/obs-studio"
  ];
}
