{ pkgs
, colors
, ...
}:
let
  inherit (colors) xcolors;
in
{
  imports = [
    ./eww
    ./libinput-gestures.nix
    ./hyprland
    ./integration.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp

    swaybg
    swaylock-effects

    wl-clipboard
    wlr-randr
    wlogout
    wofi
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  };

  programs.mako = {
    enable = true;
    borderRadius = 16;
    borderSize = 0;
    defaultTimeout = 5000;
    font = "Roboto Regular 12";
    margin = "4,4";
    backgroundColor = xcolors.base01;
    textColor = xcolors.base06;
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

  xdg.mimeApps.defaultApplications = {
    "application/mxf" = "mpv.desktop";
    "application/sdp" = "mpv.desktop";
    "application/smil" = "mpv.desktop";
    "application/streamingmedia" = "mpv.desktop";
    "application/vnd.apple.mpegurl" = "mpv.desktop";
    "application/vnd.ms-asf" = "mpv.desktop";
    "application/vnd.rn-realmedia" = "mpv.desktop";
    "application/vnd.rn-realmedia-vbr" = "mpv.desktop";
    "application/x-cue" = "mpv.desktop";
    "application/x-extension-m4a" = "mpv.desktop";
    "application/x-extension-mp4" = "mpv.desktop";
    "application/x-matroska" = "mpv.desktop";
    "application/x-mpegurl" = "mpv.desktop";
    "application/x-ogm" = "mpv.desktop";
    "application/x-ogm-video" = "mpv.desktop";
    "application/x-shorten" = "mpv.desktop";
    "application/x-smil" = "mpv.desktop";
    "application/x-streamingmedia" = "mpv.desktop";
    "video/3gp" = "mpv.desktop";
    "video/3gpp" = "mpv.desktop";
    "video/3gpp2" = "mpv.desktop";
    "video/avi" = "mpv.desktop";
    "video/divx" = "mpv.desktop";
    "video/dv" = "mpv.desktop";
    "video/fli" = "mpv.desktop";
    "video/flv" = "mpv.desktop";
    "video/mkv" = "mpv.desktop";
    "video/mp2t" = "mpv.desktop";
    "video/mp4" = "mpv.desktop";
    "video/mp4v-es" = "mpv.desktop";
    "video/mpeg" = "mpv.desktop";
    "video/msvideo" = "mpv.desktop";
    "video/ogg" = "mpv.desktop";
    "video/quicktime" = "mpv.desktop";
    "video/vnd.divx" = "mpv.desktop";
    "video/vnd.mpegurl" = "mpv.desktop";
    "video/vnd.rn-realvideo" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/x-avi" = "mpv.desktop";
    "video/x-flc" = "mpv.desktop";
    "video/x-flic" = "mpv.desktop";
    "video/x-flv" = "mpv.desktop";
    "video/x-m4v" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/x-mpeg2" = "mpv.desktop";
    "video/x-mpeg3" = "mpv.desktop";
    "video/x-ms-afs" = "mpv.desktop";
    "video/x-ms-asf" = "mpv.desktop";
    "video/x-ms-wmv" = "mpv.desktop";
    "video/x-ms-wmx" = "mpv.desktop";
    "video/x-ms-wvxvideo" = "mpv.desktop";
    "video/x-msvideo" = "mpv.desktop";
    "video/x-ogm" = "mpv.desktop";
    "video/x-ogm+ogg" = "mpv.desktop";
    "video/x-theora" = "mpv.desktop";
    "video/x-theora+ogg" = "mpv.desktop";
  };

  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [ wlrobs ];

  services.gammastep = {
    enable = true;
    provider = "geoclue2";
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
