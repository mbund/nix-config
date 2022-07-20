{ pkgs, colors, ... }:
let
  inherit (colors) xcolors;
in
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
    package = pkgs.vscodium.fhs;
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
    font.name = "Meslo Nerd Font";
    font.size = 11;
    settings = {
      hide_window_decorations = "yes";

      scrollback_lines = 10000;
      copy_on_select = "clipboard";

      enable_audio_bell = "no";
      visual_bell_duration = "0.1";
      visual_bell_color = xcolors.base05;

      dynamic_background_opacity = "yes";
      # background_opacity = "0.9";

      foreground = xcolors.base05;
      background = xcolors.base00;

      # black
      color0 = xcolors.base02;
      color8 = xcolors.base03;

      # red
      color1 = xcolors.base08;
      color9 = xcolors.base08;

      # green
      color2 = xcolors.base0B;
      color10 = xcolors.base0B;

      # yellow
      color3 = xcolors.base0A;
      color11 = xcolors.base0A;

      # blue
      color4 = xcolors.base0D;
      color12 = xcolors.base0D;

      # magenta
      color5 = xcolors.base0E;
      color13 = xcolors.base0E;

      # cyan
      color6 = xcolors.base0C;
      color14 = xcolors.base0C;

      # white
      color7 = xcolors.base05;
      color15 = xcolors.base06;
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
