{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
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
    dunst
    mpd
    wlr-randr
    wlsunset
    wl-clipboard
    brightnessctl
    pamixer
    swayidle
    libqalculate
    (rofi-wayland.override {plugins = with pkgs; [rofi-emoji rofi-calc];})
  ];

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
      ".config/hypr"
      ".config/waybar"
      ".config/rofi"
    ];
    files = [
      ".config/dolphinrc"
    ];
  };

  systemd.user.sessionVariables = {
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
