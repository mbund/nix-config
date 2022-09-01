{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      libnotify
      hyprpaper
      waybar
      grim
      slurp
      wf-recorder
      imv
      zathura
      dolphin
      ark
      swaybg
      swaylock-effects
      wlr-randr
      wlsunset
      wl-clipboard
      brightnessctl
      pamixer
      libqalculate
      (rofi-wayland.override {plugins = with pkgs; [rofi-emoji rofi-calc];})
    ]
    ++ (
      builtins.map
      (script: pkgs.writeShellScriptBin script (builtins.readFile (./scripts + "/${script}")))
      (builtins.attrNames (builtins.readDir ./scripts))
    );

  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [wlrobs];

  xdg.configFile."hypr/hyprland.conf".source = ./hypr/hyprland.conf;
  xdg.configFile."rofi/config.rasi".source = ./rofi/config.rasi;
  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  services.swayidle.enable = true;
  services.swayidle.events = [
    {
      event = "before-sleep";
      command = "lock";
    }
    {
      event = "lock";
      command = "lock";
    }
  ];
  services.swayidle.timeouts = [
    {
      timeout = 60;
      command = "lock";
    }
  ];

  services.dunst.enable = true;

  programs.mpv.enable = true;
  programs.mpv.config = {
    profile = "gpu-hq";
    gpu-context = "wayland";
    vo = "gpu";
    hwdec = "auto";
  };

  services.mpd.enable = true;

  home.pointerCursor.x11.enable = true;
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.size = 16;
  home.pointerCursor.package = pkgs.nur.repos.ambroisie.vimix-cursors;
  home.pointerCursor.name = "Vimix-white-cursors";
  gtk.enable = true;
  gtk.font = {
    name = "Roboto";
    package = pkgs.roboto;
  };
  gtk.iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
  qt.enable = true;
  qt.platformTheme = "gnome";
  qt.style = {
    name = "adwaita";
    package = pkgs.adwaita-qt;
  };

  home.persistence."/nix/state/home/mbund" = {
    directories = [
      ".config/evolution"
      ".local/share/evolution"

      ".local/share/flatpak"
      ".var/app"

      ".config/hypr"
    ];
    files = [
      ".config/dolphinrc"
    ];
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
