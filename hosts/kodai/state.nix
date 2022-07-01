{
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/docker"
      "/var/lib/tailscale"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    users.mbund.directories = [
      ".cache/nix-index"
      ".cache/zsh"
      ".local/share/direnv"
      ".local/share/zsh"
      "src"
      "tmp"
      { directory = ".ssh"; mode = "0700"; }
    ];
  };
}