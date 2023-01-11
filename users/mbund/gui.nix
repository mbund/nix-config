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

    (with eclipses;
      eclipseWithPlugins {
        eclipse = eclipse-java;
        plugins = [
          plugins.checkstyle
          plugins.spotbugs
          (plugins.buildEclipseUpdateSite rec {
            name = "subclipse-${version}";
            version = "4.3.0";
            src = fetchzip {
              stripRoot = false;
              url = "https://subclipse.github.io/updates/subclipse/subclipse-${version}.zip";
              sha256 = "sha256-9N4tuvh/ByhwC/nFDQO/Ow0FDq15vw/XWMxOrY7Y36Y=";
            };
          })
        ];
      })
  ];
}
