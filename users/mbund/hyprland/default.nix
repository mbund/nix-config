{ config, lib, pkgs, host, ... }:
let
  screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
  bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
in
{
  home.packages = with pkgs; [
    dunst
    libnotify
    grim
    slurp
    wf-recorder
    screen
    bandw
    wofi
    pqiv
    swaybg
    swaylock-effects
    wlr-randr
    wlsunset
    wl-clipboard
    eww-wayland
    pamixer
    brightnessctl
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  xdg.configFile."wofi.css".source = ./wofi.css;
  xdg.configFile."eww".source = ./eww;

  xdg.configFile."hypr/hyprland.conf".text = ''
    ${lib.optionals (host == "kodai") ''
      monitor=eDP-1,1920x1080@60,0x0,1
      exec-once=swaybg -i $NIX_CONFIG_DIR/users/mbund/wallpapers/wavy_lines_v02_5120x2880.png
    ''}

    ${builtins.readFile ./hyprland.conf}
  '';

  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [ wlrobs ];

  services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "top-left";
        offset = "60x12";
        separator_height = 2;
        padding = 12;
        horizontal_padding = 12;
        text_icon_padding = 12;
        frame_width = 4;
        separator_color = "frame";
        idle_threshold = 120;
        font = "JetBrainsMono Nerdfont 12";
        line_height = 0;
        format = "<b>%s</b>\n%b";
        alignment = "center";
        icon_position = "off";
        startup_notification = "false";
        corner_radius = 12;

        frame_color = "#44465c";
        background = "#303241";
        foreground = "#d9e0ee";
        timeout = 2;
      };
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerdfont:size=7:line-height=16px";
        pad = "12x12";
      };
      colors = {
        foreground = "d9e0ee";
        background = "292a37";
        ## Normal/regular colors (color palette 0-7)
        regular0 = "303241"; # black
        regular1 = "ec6a88";
        regular2 = "3fdaa4";
        regular3 = "efb993";
        regular4 = "3fc6de";
        regular5 = "b771dc";
        regular6 = "6be6e6";
        regular7 = "d9e0ee";

        bright0 = "393a4d"; # bright black
        bright1 = "e95678"; # bright red
        bright2 = "29d398"; # bright green
        bright3 = "efb993"; # bright yellow
        bright4 = "26bbd9";
        bright5 = "b072d1"; # bright magenta
        bright6 = "59e3e3"; # bright cyan
        bright7 = "d9e0ee"; # bright white
      };
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

  gtk = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerdfont 12";
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Catppuccin-orange-dark-compact";
      package = pkgs.catppuccin-gtk.override { size = "compact"; };
    };
  };

  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    size = 16;

    package = pkgs.nur.repos.ambroisie.vimix-cursors;
    name = "Vimix-white-cursors";
    # name = "Vimix-cursors";
  };

  home.sessionVariables = {
    XCURSOR_THEME = config.xsession.pointerCursor.name;
    XCURSOR_SIZE = config.xsession.pointerCursor.size;
    MOZ_ENABLE_WAYLAND = 1;
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    GTK_USE_PORTAL = 1;
    SDL_VIDEODRIVER = "wayland";
    NIXOS_OZONE_WL = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };
}
