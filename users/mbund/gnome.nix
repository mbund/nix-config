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
        "tailscale-status@maxgallup.github.com"
        "Vitals@CoreCoding.com"
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
    "org/gnome/shell/extensions/vitals" = {
      position-in-panel = 0; # left
      show-battery = true;
      use-higher-precision = true;
      hot-sensors = [
        "__temperature_avg__"
        "_processor_frequency_"
        "_processor_average_"
        "__network-rx_max__"
        "__network-tx_max__"
      ];
    };
    "org/gnome/settings-daemon/plugins/power" =
      if (host == "kuro")
      then {sleep-inactive-ac-type = "nothing";}
      else {};
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
    caffeine
    clipboard-history
    expandable-notifications
    gsconnect
    just-perfection
    night-theme-switcher
    sound-output-device-chooser
    tailscale-status
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

  xdg.mimeApps.associations.added = {
    "x-scheme-handler/http" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/mailto" = "org.gnome.Evolution.desktop";
    "audio/wav" = "io.bassi.Amberol.desktop";
    "audio/webm" = "io.bassi.Amberol.desktop";
    "audio/x-aac" = "io.bassi.Amberol.desktop";
    "audio/x-aiff" = "io.bassi.Amberol.desktop";
    "audio/x-ape" = "io.bassi.Amberol.desktop";
    "audio/x-flac" = "io.bassi.Amberol.desktop";
    "audio/x-it" = "io.bassi.Amberol.desktop";
    "audio/x-m4a" = "io.bassi.Amberol.desktop";
    "audio/x-m4b" = "io.bassi.Amberol.desktop";
    "audio/x-matroska" = "io.bassi.Amberol.desktop";
    "audio/x-mod" = "io.bassi.Amberol.desktop";
    "audio/x-mp1" = "io.bassi.Amberol.desktop";
    "audio/x-mp2" = "io.bassi.Amberol.desktop";
    "audio/x-mp3" = "io.bassi.Amberol.desktop";
    "audio/x-mpg" = "io.bassi.Amberol.desktop";
    "audio/x-mpeg" = "io.bassi.Amberol.desktop";
    "audio/x-mpegurl" = "io.bassi.Amberol.desktop";
    "audio/x-ms-asf" = "io.bassi.Amberol.desktop";
    "audio/x-ms-asx" = "io.bassi.Amberol.desktop";
    "audio/x-ms-wax" = "io.bassi.Amberol.desktop";
    "audio/x-ms-wma" = "io.bassi.Amberol.desktop";
    "audio/x-musepack" = "io.bassi.Amberol.desktop";
    "audio/x-opus+ogg" = "io.bassi.Amberol.desktop";
    "audio/x-pn-aiff" = "io.bassi.Amberol.desktop";
    "audio/x-pn-au" = "io.bassi.Amberol.desktop";
    "audio/x-pn-realaudio" = "io.bassi.Amberol.desktop";
    "audio/x-pn-realaudio-plugin" = "io.bassi.Amberol.desktop";
    "audio/x-pn-wav" = "io.bassi.Amberol.desktop";
    "audio/x-pn-windows-acm" = "io.bassi.Amberol.desktop";
    "audio/x-realaudio" = "io.bassi.Amberol.desktop";
    "audio/x-real-audio" = "io.bassi.Amberol.desktop";
    "audio/x-s3m" = "io.bassi.Amberol.desktop";
    "audio/x-sbc" = "io.bassi.Amberol.desktop";
    "audio/x-scpls" = "io.bassi.Amberol.desktop";
    "audio/x-shorten" = "io.bassi.Amberol.desktop";
    "audio/x-speex" = "io.bassi.Amberol.desktop";
    "audio/x-stm" = "io.bassi.Amberol.desktop";
    "audio/x-tta" = "io.bassi.Amberol.desktop";
    "audio/x-wav" = "io.bassi.Amberol.desktop";
    "audio/x-wavpack" = "io.bassi.Amberol.desktop";
    "audio/x-vorbis" = "io.bassi.Amberol.desktop";
    "audio/x-xm" = "io.bassi.Amberol.desktop";
    "video/3gp" = "io.github.celluloid_player.Celluloid.desktop";
    "video/3gpp" = "io.github.celluloid_player.Celluloid.desktop";
    "video/3gpp2" = "io.github.celluloid_player.Celluloid.desktop";
    "video/divx" = "io.github.celluloid_player.Celluloid.desktop";
    "video/dv" = "io.github.celluloid_player.Celluloid.desktop";
    "video/fli" = "io.github.celluloid_player.Celluloid.desktop";
    "video/flv" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mp2t" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mp4" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mp4v-es" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mpeg" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mpeg-system" = "io.github.celluloid_player.Celluloid.desktop";
    "video/msvideo" = "io.github.celluloid_player.Celluloid.desktop";
    "video/ogg" = "io.github.celluloid_player.Celluloid.desktop";
    "video/quicktime" = "io.github.celluloid_player.Celluloid.desktop";
    "video/vnd.mpegurl" = "io.github.celluloid_player.Celluloid.desktop";
    "video/vnd.rn-realvideo" = "io.github.celluloid_player.Celluloid.desktop";
    "video/webm" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-avi" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-flc" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-fli" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-flv" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-m4v" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-matroska" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-mpeg" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-mpeg-system" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-mpeg2" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-ms-asf" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-ms-wm" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-ms-wmv" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-ms-wmx" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-msvideo" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-nsv" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-theora" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-theora+ogg" = "io.github.celluloid_player.Celluloid.desktop";
    "image/bmp" = "org.gnome.eog.desktop";
    "image/gif" = "org.gnome.eog.desktop";
    "image/jpg" = "org.gnome.eog.desktop";
    "image/pjpeg" = "org.gnome.eog.desktop";
    "image/png" = "org.gnome.eog.desktop";
    "image/tiff" = "org.gnome.eog.desktop";
    "image/x-bmp" = "org.gnome.eog.desktop";
    "image/x-gray" = "org.gnome.eog.desktop";
    "image/x-icb" = "org.gnome.eog.desktop";
    "image/x-ico" = "org.gnome.eog.desktop";
    "image/x-png" = "org.gnome.eog.desktop";
    "image/x-portable-anymap" = "org.gnome.eog.desktop";
    "image/x-portable-bitmap" = "org.gnome.eog.desktop";
    "image/x-portable-graymap" = "org.gnome.eog.desktop";
    "image/x-portable-pixmap" = "org.gnome.eog.desktop";
    "image/x-xbitmap" = "org.gnome.eog.desktop";
    "image/x-xpixmap" = "org.gnome.eog.desktop";
    "image/x-pcx" = "org.gnome.eog.desktop";
    "image/svg+xml" = "org.gnome.eog.desktop";
    "image/svg+xml-compressed" = "org.gnome.eog.desktop";
    "image/vnd.wap.wbmp" = "org.gnome.eog.desktop";
    "image/x-icns" = "org.gnome.eog.desktop";
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/mailto" = "org.gnome.Evolution.desktop";
    "audio/x-vorbis+ogg" = "io.bassi.Amberol.desktop";
    "audio/wav" = "io.bassi.Amberol.desktop";
    "audio/webm" = "io.bassi.Amberol.desktop";
    "audio/x-aac" = "io.bassi.Amberol.desktop";
    "audio/x-aiff" = "io.bassi.Amberol.desktop";
    "audio/x-ape" = "io.bassi.Amberol.desktop";
    "audio/x-flac" = "io.bassi.Amberol.desktop";
    "audio/x-it" = "io.bassi.Amberol.desktop";
    "audio/x-m4a" = "io.bassi.Amberol.desktop";
    "audio/x-m4b" = "io.bassi.Amberol.desktop";
    "audio/x-matroska" = "io.bassi.Amberol.desktop";
    "audio/x-mod" = "io.bassi.Amberol.desktop";
    "audio/x-mp1" = "io.bassi.Amberol.desktop";
    "audio/x-mp2" = "io.bassi.Amberol.desktop";
    "audio/x-mp3" = "io.bassi.Amberol.desktop";
    "audio/x-mpg" = "io.bassi.Amberol.desktop";
    "audio/x-mpeg" = "io.bassi.Amberol.desktop";
    "audio/x-mpegurl" = "io.bassi.Amberol.desktop";
    "audio/x-ms-asf" = "io.bassi.Amberol.desktop";
    "audio/x-ms-asx" = "io.bassi.Amberol.desktop";
    "audio/x-ms-wax" = "io.bassi.Amberol.desktop";
    "audio/x-ms-wma" = "io.bassi.Amberol.desktop";
    "audio/x-musepack" = "io.bassi.Amberol.desktop";
    "audio/x-opus+ogg" = "io.bassi.Amberol.desktop";
    "audio/x-pn-aiff" = "io.bassi.Amberol.desktop";
    "audio/x-pn-au" = "io.bassi.Amberol.desktop";
    "audio/x-pn-realaudio" = "io.bassi.Amberol.desktop";
    "audio/x-pn-realaudio-plugin" = "io.bassi.Amberol.desktop";
    "audio/x-pn-wav" = "io.bassi.Amberol.desktop";
    "audio/x-pn-windows-acm" = "io.bassi.Amberol.desktop";
    "audio/x-realaudio" = "io.bassi.Amberol.desktop";
    "audio/x-real-audio" = "io.bassi.Amberol.desktop";
    "audio/x-s3m" = "io.bassi.Amberol.desktop";
    "audio/x-sbc" = "io.bassi.Amberol.desktop";
    "audio/x-scpls" = "io.bassi.Amberol.desktop";
    "audio/x-shorten" = "io.bassi.Amberol.desktop";
    "audio/x-speex" = "io.bassi.Amberol.desktop";
    "audio/x-stm" = "io.bassi.Amberol.desktop";
    "audio/x-tta" = "io.bassi.Amberol.desktop";
    "audio/x-wav" = "io.bassi.Amberol.desktop";
    "audio/x-wavpack" = "io.bassi.Amberol.desktop";
    "audio/x-vorbis" = "io.bassi.Amberol.desktop";
    "audio/x-xm" = "io.bassi.Amberol.desktop";
    "video/x-ogm+ogg" = "io.github.celluloid_player.Celluloid.desktop";
    "video/3gp" = "io.github.celluloid_player.Celluloid.desktop";
    "video/3gpp" = "io.github.celluloid_player.Celluloid.desktop";
    "video/3gpp2" = "io.github.celluloid_player.Celluloid.desktop";
    "video/divx" = "io.github.celluloid_player.Celluloid.desktop";
    "video/dv" = "io.github.celluloid_player.Celluloid.desktop";
    "video/fli" = "io.github.celluloid_player.Celluloid.desktop";
    "video/flv" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mp2t" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mp4" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mp4v-es" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mpeg" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mpeg-system" = "io.github.celluloid_player.Celluloid.desktop";
    "video/msvideo" = "io.github.celluloid_player.Celluloid.desktop";
    "video/ogg" = "io.github.celluloid_player.Celluloid.desktop";
    "video/quicktime" = "io.github.celluloid_player.Celluloid.desktop";
    "video/vnd.mpegurl" = "io.github.celluloid_player.Celluloid.desktop";
    "video/vnd.rn-realvideo" = "io.github.celluloid_player.Celluloid.desktop";
    "video/webm" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-avi" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-flc" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-fli" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-flv" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-m4v" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-matroska" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-mpeg" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-mpeg-system" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-mpeg2" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-ms-asf" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-ms-wm" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-ms-wmv" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-ms-wmx" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-msvideo" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-nsv" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-theora" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-theora+ogg" = "io.github.celluloid_player.Celluloid.desktop";
    "image/jpeg" = "org.gnome.eog.desktop";
    "image/bmp" = "org.gnome.eog.desktop";
    "image/gif" = "org.gnome.eog.desktop";
    "image/jpg" = "org.gnome.eog.desktop";
    "image/pjpeg" = "org.gnome.eog.desktop";
    "image/png" = "org.gnome.eog.desktop";
    "image/tiff" = "org.gnome.eog.desktop";
    "image/x-bmp" = "org.gnome.eog.desktop";
    "image/x-gray" = "org.gnome.eog.desktop";
    "image/x-icb" = "org.gnome.eog.desktop";
    "image/x-ico" = "org.gnome.eog.desktop";
    "image/x-png" = "org.gnome.eog.desktop";
    "image/x-portable-anymap" = "org.gnome.eog.desktop";
    "image/x-portable-bitmap" = "org.gnome.eog.desktop";
    "image/x-portable-graymap" = "org.gnome.eog.desktop";
    "image/x-portable-pixmap" = "org.gnome.eog.desktop";
    "image/x-xbitmap" = "org.gnome.eog.desktop";
    "image/x-xpixmap" = "org.gnome.eog.desktop";
    "image/x-pcx" = "org.gnome.eog.desktop";
    "image/svg+xml" = "org.gnome.eog.desktop";
    "image/svg+xml-compressed" = "org.gnome.eog.desktop";
    "image/vnd.wap.wbmp" = "org.gnome.eog.desktop";
    "image/x-icns" = "org.gnome.eog.desktop";
  };
}
