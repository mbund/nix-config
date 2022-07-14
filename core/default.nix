{ lib, pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./networking.nix
  ];

  boot.kernelParams = [ "log_buf_len=10M" ];

  environment.systemPackages = with pkgs; [
    git
    vim
    helix
    wget
    curl
    rclone
    rsync
    man-pages
  ];

  programs.mosh.enable = true;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = lib.mkDefault "no";

  documentation.dev.enable = true;

  users.mutableUsers = false;
}
