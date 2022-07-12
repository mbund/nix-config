{ config, lib, pkgs, ... }:
{
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
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "blur-my-shell@aunetx"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "expandable-notifications@kaan.g.inam.org"
        "gsconnect@andyholmes.github.io"
        "just-perfection-desktop@just-perfection"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "nightthemeswitcher@romainvigier.fr"
        "sound-output-device-chooser@kgshank.net"
        "tailscale-status@maxgallup.github.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];

      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "torbrowser.desktop"
        "codium.desktop"
        "kitty.desktop"
        "ferdium.desktop"
        "org.gnome.Evolution.desktop"
        "org.gnome.Calendar.desktop"
      ];
    };
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };
    "org/gnome/desktop/input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us" ]) (lib.hm.gvariant.mkTuple [ "xkb" "us+colemak_dh" ]) ];
      xkb-options = [ "caps:escape_shifted_capslock" ];
    };
    "org/gnome/shell/extensions/just-perfection" = {
      search = false; # disable search bar in overview
      workspace-switcher-size = 10; # make workspace switchers larger
      background-menu = false; # disable right click on desktop
      workspace-wrap-around = true; # wrap last workspace to first, and first to last
      workspace-switcher-should-show = true; # show even if only one workspace
      top-panel-position = 1; # bottom
      clock-menu-position = 2; # left
      notification-banner-position = 3; # bottom left
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.jpg";
    };
  };

  home.packages = with pkgs; with pkgs.gnome; with pkgs.gnomeExtensions; [
    amberol
    blanket
    celluloid
    fragments
    helvum
    junction
    kooha
    metadata-cleaner

    dconf-editor
    gnome-tweaks

    alphabetical-app-grid
    appindicator
    bluetooth-quick-connect
    blur-my-shell
    expandable-notifications
    gsconnect
    just-perfection
    night-theme-switcher
    sound-output-device-chooser
    tailscale-status
  ];

  services.easyeffects.enable = true;

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [ obs-gstreamer ];

  nixpkgs.config.firefox.enableGnomeExtensions = true;

  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    size = 16;

    package = pkgs.nur.repos.ambroisie.vimix-cursors;
    name = "Vimix-white-cursors";
    # name = "Vimix-cursors";
  };

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

  gtk = {
    enable = true;

    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita";
      package = pkgs.adwaita-qt;
    };
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
