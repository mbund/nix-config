{pkgs, ...}: {
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    meslo-lgs-nf
    liberation_ttf
    roboto
    roboto-mono
  ];
}
