{ pkgs, ... }:
{
  imports = [
    ./firefox
  ];

  home.packages = with pkgs; [
    audacity
    blender
    ferdium
    gimp
    godot
    inkscape
    kdenlive
    krita
    minecraft
    onlyoffice-bin
    qbittorrent
    superTuxKart
    tor-browser-bundle-bin
    vlc
    xorg.xeyes
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
  };

  programs.obs-studio.enable = true;

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
    ];
  };

  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 11;
    settings = {
      dynamic_background_opacity = "yes";
      hide_window_decorations = "yes";
      scrollback_lines = 10000;
      copy_on_select = "clipboard";
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
