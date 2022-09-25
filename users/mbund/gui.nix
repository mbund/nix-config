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
    godot
    wireshark
    obs-studio
    ferdium
    nextcloud-client
    signal-desktop
    monero-gui
    qbittorrent
    cool-retro-term
    # tor-browser-bundle-bin
    firefox
    librewolf
    xorg.xeyes
    airshipper
    moonlight-qt
    superTuxKart
    zoom-us
  ];
}
