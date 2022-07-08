{ pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./networking.nix
    ./openssh.nix
    ./zsh.nix
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
  ];

  users.mutableUsers = false;
}
