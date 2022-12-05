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
    vscodium.fhs
    ungoogled-chromium
    alacritty
    foot
    godot_4
    wireshark
    obs-studio
    element-desktop
    discord
    nextcloud-client
    signal-desktop
    monero-gui
    qbittorrent
    cool-retro-term
    tor-browser-bundle-bin
    gparted
    firefox
    librewolf
    xorg.xeyes
    airshipper
    xonotic
    moonlight-qt
    superTuxKart
    zoom-us
    ghidra
  ];
}
