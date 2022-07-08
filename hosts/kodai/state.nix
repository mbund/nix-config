{
  environment.persistence."/state" = {
    users.mbund.directories = [
      "xdg"
      "data"
      ".cache/nix-index"
      ".cache/zsh"
      ".local/share/direnv"
      ".local/share/zsh"
      { directory = ".ssh"; mode = "0700"; }
      { directory = ".gnupg"; mode = "0700"; }
    ];
  };
}
