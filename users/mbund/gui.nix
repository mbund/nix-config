{pkgs, ...}: {
  home.packages = with pkgs; [
    airshipper
    minecraft
    moonlight-qt
    superTuxKart

    audacity
    blender
    gimp
    inkscape
    krita
    kdenlive
    onlyoffice-bin
    vlc

    godot
    wireshark
    gparted

    ferdium
    signal-desktop

    monero-gui
    qbittorrent
    tor-browser-bundle-bin
    firefox
    librewolf
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
  };

  programs.obs-studio.enable = true;

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
      "--ozone-platform=wayland"
    ];
  };

  programs.alacritty.enable = true;
  xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;

  programs.kitty = {
    enable = true;
    font.name = "Meslo Nerd Font";
    font.size = 11;
    theme = "One Dark";
    settings = {
      hide_window_decorations = "yes";

      scrollback_lines = 10000;
      copy_on_select = "clipboard";

      dynamic_background_opacity = "yes";
      # background_opacity = "0.9";
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      gpu-context = "wayland";
      vo = "gpu";
      hwdec = "auto";
    };
  };

  home.persistence."/nix/state/home/mbund".directories = [
    ".local/share/airshipper"
    ".minecraft"
    ".mozilla"
    ".librewolf"
    ".config/obs-studio"
    ".config/Signal"
    ".config/supertuxkart"
    ".config/VSCodium"
    ".vscode-oss"
    ".config/chromium"
    ".config/Ferdium"
    ".config/inkscape"
    ".config/krita"
  ];
}
