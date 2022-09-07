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
    # tor-browser-bundle-bin
    firefox
    librewolf
    xorg.xeyes
    airshipper
    minecraft
    moonlight-qt
    superTuxKart
  ];
}
