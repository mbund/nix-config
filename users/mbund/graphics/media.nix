{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    pavucontrol
    playerctl
    pulsemixer
    imv
  ];

  xdg.mimeApps.defaultApplications = {
    "image/bmp" = lib.mkForce "imv.desktop";
    "image/gif" = lib.mkForce "imv.desktop";
    "image/jpeg" = lib.mkForce "imv.desktop";
    "image/jpg" = lib.mkForce "imv.desktop";
    "image/pjpeg" = lib.mkForce "imv.desktop";
    "image/png" = lib.mkForce "imv.desktop";
    "image/tiff" = lib.mkForce "imv.desktop";
    "image/x-bmp" = lib.mkForce "imv.desktop";
    "image/x-pcx" = lib.mkForce "imv.desktop";
    "image/x-png" = lib.mkForce "imv.desktop";
    "image/x-portable-anymap" = lib.mkForce "imv.desktop";
    "image/x-portable-bitmap" = lib.mkForce "imv.desktop";
    "image/x-portable-graymap" = lib.mkForce "imv.desktop";
    "image/x-portable-pixmap" = lib.mkForce "imv.desktop";
    "image/x-tga" = lib.mkForce "imv.desktop";
    "image/x-xbitmap" = lib.mkForce "imv.desktop";
  };

  programs.ncmpcpp = {
    enable = false;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    settings = { ncmpcpp_directory = "~/.local/share/ncmpcpp"; };
  };

  programs.obs-studio.enable = true;

  services.easyeffects.enable = true;

  services.mpd = {
    enable = false;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      zeroconf_enabled "yes"
      zeroconf_name "MPD @ %h"
      input {
          plugin "curl"
        }
        audio_output {
          type "fifo"
          name "Visualizer"
          path "/tmp/mpd.fifo"
          format    "48000:16:2"
        }
        audio_output {
          type "pulse"
          name "PulseAudio"
        }
    '';
    network.listenAddress = "any";
    network.startWhenNeeded = true;
  };

  services.mpdris2.enable = false;

  services.playerctld.enable = true;
}
