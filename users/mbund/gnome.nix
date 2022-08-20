{
  config,
  lib,
  pkgs,
  host,
  ...
}: {
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      resize-with-right-button = true;
      button-layout = ":close";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
    "org/gnome/shell" = {
      welcome-dialog-last-shown-version = "999999999";
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "clipboard-history@alexsaveau.dev"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "expandable-notifications@kaan.g.inam.org"
        "gsconnect@andyholmes.github.io"
        "just-perfection-desktop@just-perfection"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "nightthemeswitcher@romainvigier.fr"
        "sound-output-device-chooser@kgshank.net"
        "Vitals@CoreCoding.com"
      ];

      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "chromium-browser.desktop"
        "firefox.desktop"
        "librewolf.desktop"
        "torbrowser.desktop"
        "codium.desktop"
        "Alacritty.desktop"
        "org.gnome.Evolution.desktop"
        "ferdium.desktop"
        "signal-desktop.desktop"
        "org.gnome.Calendar.desktop"
      ];
    };
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };
    "org/gnome/desktop/input-sources" = {
      sources = [(lib.hm.gvariant.mkTuple ["xkb" "us"]) (lib.hm.gvariant.mkTuple ["xkb" "us+colemak_dh"])];
      xkb-options = ["caps:escape_shifted_capslock"];
    };
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
    };
    "org/gnome/shell/extensions/just-perfection" = {
      search = false; # disable search bar in overview
      workspace-switcher-size = 15; # make workspace switchers larger
      background-menu = false; # disable right click on desktop
      workspace-switcher-should-show = true; # show even if only one workspace
      notification-banner-position = 2; # top right
    };
    "org/gnome/shell/extensions/vitals" =
      {
        position-in-panel = 0; # left
        use-higher-precision = true;
      }
      // (lib.optionalAttrs (host == "kumitate") {
        show-battery = true;
        battery-slot = 1;
        hot-sensors = ["_battery_rate_" "__network-rx_max__" "__network-tx_max__"];
      });
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = lib.optional (builtins.elem host ["kuro"]) "nothing";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.jpg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-d.jpg";
    };
  };

  home.packages = with pkgs;
  with pkgs.gnome;
  with pkgs.gnomeExtensions; [
    gnome-power-manager
    amberol
    blanket
    celluloid
    fragments

    dconf-editor
    gnome-tweaks

    alphabetical-app-grid
    appindicator
    bluetooth-quick-connect
    blur-my-shell
    caffeine
    clipboard-history
    expandable-notifications
    gsconnect
    just-perfection
    night-theme-switcher
    sound-output-device-chooser
    vitals
  ];

  services.easyeffects.enable = true;

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [obs-gstreamer];

  nixpkgs.config.firefox.enableGnomeExtensions = true;

  xdg.configFile."autostart/AutostartGnomeExtensions.desktop".text = ''
    [Desktop Entry]
    Name=AutostartGnomeExtensions
    GenericName=Gnome extenion script
    Comment=Uses gsettings to automatically start gnome extensions on login
    Exec=gsettings set org.gnome.shell disable-user-extensions false
    Terminal=false
    Type=Application
    X-GNOME-Autostart-enabled=true
  '';

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
    files = [
      ".config/monitors.xml"
    ];
    directories = [
      ".config/evolution"
      ".local/share/evolution"
      ".local/share/flatpak"
      ".var/app"
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
