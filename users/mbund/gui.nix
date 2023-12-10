{pkgs, ...}: {
  home.packages = with pkgs; [
    audacity
    blender
    gimp
    inkscape
    krita
    kdenlive
    obs-studio
    anki
    vlc
    mpv
    xournalpp
    endeavour
    onlyoffice-bin
    libreoffice
    vscodium
    vscode-fhs
    beekeeper-studio
    lapce
    openlens
    metadata-cleaner
    alacritty
    jetbrains.idea-community
    cool-retro-term
    xorg.xeyes
    tor-browser-bundle-bin
    ungoogled-chromium
    octaveFull
    firefox
    ghidra
    wireshark
    superTuxKart
    xonotic
    qbittorrent
    monero-gui
    godot_4
    gparted
    filezilla
    signal-desktop
  ];
}
