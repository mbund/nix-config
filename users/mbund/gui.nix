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
    # vscodium
    vscode
    endeavour
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
    filezilla
    (with eclipses;
      eclipseWithPlugins {
        eclipse = eclipse-java;
        jvmArgs = ["--add-opens=java.base/java.lang=ALL-UNNAMED"];
      })
    jetbrains.idea-community
  ];
}
