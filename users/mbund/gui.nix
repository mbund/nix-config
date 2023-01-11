{pkgs, ...}: {
  home.packages = with pkgs; [
    audacity
    blender
    gimp
    inkscape
    krita
    kdenlive
    onlyoffice-bin
    vlc
    mpv
    xournalpp
    eclipses.eclipse-java
    vscodium
    lapce
    ungoogled-chromium
    alacritty
    godot_4
    wireshark
    obs-studio
    signal-desktop
    monero-gui
    qbittorrent
    cool-retro-term
    tor-browser-bundle-bin
    gparted
    firefox
    xorg.xeyes
    airshipper
    xonotic
    moonlight-qt
    superTuxKart
    ghidra
  ];
}
