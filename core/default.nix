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
    btop
    foot.terminfo
    vim
    helix
    wget
    curl
    rclone
    rsync
  ];

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.mutableUsers = false;
}
