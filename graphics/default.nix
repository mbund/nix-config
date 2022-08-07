{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
  ];

  services.xserver.desktopManager.xterm.enable = lib.mkForce false;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];
}
