{ pkgs, ... }: {
  home.packages = with pkgs; [
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
}
