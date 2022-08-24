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
    nextcloud-client
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
  programs.alacritty.settings = {
    window.decorations = "none";
    window.dynamic_padding = true;
    shell.program = "fish";
    env.SHELL = "fish";
    font.normal.family = "MesloLGS NF";
    font.size = 11;

    # Colors (One Dark - https://github.com/atom/atom/tree/master/packages/one-dark-syntax)
    colors = {
      primary = {
        background = "#282c34";
        foreground = "#abb2bf";
      };
      cursor = {
        text = "CellBackground";
        cursor = "#528bff"; # syntax-cursor-color
      };
      selection = {
        text = "CellForeground";
        background = "#3e4451"; # syntax-selection-color
      };
      normal = {
        black = "#5c6370"; # mono-3
        red = "#e06c75"; # red 1
        green = "#98c379";
        yellow = "#e5c07b"; # orange 2
        blue = "#61afef";
        magenta = "#c678dd";
        cyan = "#56b6c2";
        white = "#828997"; # mono-2
      };
    };
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
    ".config/Nextcloud"
    ".config/inkscape"
    ".config/krita"
  ];
}
