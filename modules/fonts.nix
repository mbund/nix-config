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
    carlito
    dejavu_fonts
    ipafont
    kochi-substitute
    source-code-pro
    ttf_bitstream_vera
  ];

  services.xserver.desktopManager.xterm.enable = lib.mkForce false;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "DejaVu Sans Mono"
      "IPAGothic"
    ];
    sansSerif = [
      "DejaVu Sans"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk];
}
