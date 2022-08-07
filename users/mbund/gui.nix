{pkgs, ...}: {
  imports = [
    ./firefox
  ];

  home.packages = with pkgs; [
    airshipper
    audacity
    blender
    davinci-resolve
    ferdium
    gimp
    godot
    inkscape
    kdenlive
    krita
    minecraft
    monero-gui
    moonlight-qt
    onlyoffice-bin
    qbittorrent
    superTuxKart
    tor-browser-bundle-bin
    vlc
    wireshark
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
}
