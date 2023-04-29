{
  lib,
  pkgs,
  ...
}: {
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    meslo-lgs-nf
    liberation_ttf
    roboto
    roboto-mono
    mplus-outline-fonts.githubRelease
  ];

  services.xserver.desktopManager.xterm.enable = lib.mkForce false;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];
}
