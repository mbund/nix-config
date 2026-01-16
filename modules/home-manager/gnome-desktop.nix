{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    adw-gtk3
    dconf-editor
    gnome-extension-manager
    gnome-firmware
    gnome-tweaks
    papirus-icon-theme
    wl-clipboard

    gnomeExtensions.advanced-alttab-window-switcher
    gnomeExtensions.caffeine
    gnomeExtensions.disable-workspace-animation
    gnomeExtensions.gsconnect
    gnomeExtensions.just-perfection
    gnomeExtensions.launch-new-instance

    alacritty
    keepassxc
    vscodium
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
      primary-color = "#241f31";
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:escape_shifted_capslock"];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt><Tab>"];
      switch-applications = ["<Super>Tab"];
      switch-applications-backward = ["<Shift><Super><Tab>"];

      move-to-workspace-1 = ["<Shift><Super>1"];
      switch-to-workspace-1 = ["<Super>1"];
      move-to-workspace-2 = ["<Shift><Super>2"];
      switch-to-workspace-2 = ["<Super>2"];
      move-to-workspace-3 = ["<Shift><Super>3"];
      switch-to-workspace-3 = ["<Super>3"];
      move-to-workspace-4 = ["<Shift><Super>4"];
      switch-to-workspace-4 = ["<Super>4"];
      move-to-workspace-5 = ["<Shift><Super>5"];
      switch-to-workspace-5 = ["<Super>5"];
      move-to-workspace-6 = ["<Shift><Super>6"];
      switch-to-workspace-6 = ["<Super>6"];
      move-to-workspace-7 = ["<Shift><Super>7"];
      switch-to-workspace-7 = ["<Super>7"];
      move-to-workspace-8 = ["<Shift><Super>8"];
      switch-to-workspace-8 = ["<Super>8"];
      move-to-workspace-9 = ["<Shift><Super>9"];
      switch-to-workspace-9 = ["<Super>9"];
    };
    "org/gnome/desktop/wm/preferences" = {
      resize-with-right-button = true;
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "advanced-alt-tab@G-dH.github.com"
        "caffeine@patapon.info"
        "disable-workspace-animation@ethnarque"
        "just-perfection-desktop@just-perfection"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Nautilus.desktop"
        "org.keepassxc.KeePassXC.desktop"
        "codium.desktop"
        "Alacritty.desktop"
      ];
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
    };
    "org/gnome/shell/extensions/just-perfection" = {
      search = false;
      workspace-switcher-size = 10;
      workspace-switcher-should-show = true;
    };
    "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
      switcher-popup-monitor = 2; # Monitor with focused window
    };
    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "launch terminal";
      command = "alacritty";
      binding = "<Super>Return";
    };
  };
}
