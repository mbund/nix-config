{ pkgs, ... }: {
  imports = [
    ./flameshot.nix
    ./foot.nix
    ./imv.nix
    ./integration.nix
    ./mako.nix
    ./mpv.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    swaybg
    (rofi-wayland.override (old: rec { plugins = (old.plugins or [ ]) ++ [ rofi-calc rofi-emoji rofi-power-menu ]; }))

    wl-clipboard
    wob
    brightnessctl
    pamixer
  ];

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    MOZ_ENABLE_WAYLAND = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true";
  };

  services.blueman-applet.enable = true;
  services.gpg-agent.pinentryFlavor = "gnome3";
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    tray = true;
    settings.general = {
      brightness-day = 1.0;
      brightness-night = 0.4;
    };
  };

  systemd.user.services = {
    gammastep.Unit = {
      After = [ "geoclue-agent.service" ];
      Wants = [ "geoclue-agent.service" ];
    };
    polkit = {
      Unit = {
        Description = "polkit-gnome";
        Documentation = [ "man:polkit(8)" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        RestartSec = 3;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
