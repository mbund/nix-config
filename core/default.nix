{pkgs, ...}: {
  imports = [
    ./nix.nix
    ./networking.nix
  ];

  boot.kernelParams = ["log_buf_len=10M"];

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

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.mosh.enable = true;
  services.openssh.enable = true;

  documentation.dev.enable = true;

  users.mutableUsers = false;
}
