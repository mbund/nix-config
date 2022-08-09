{nixos-hardware, ...}: {
  imports = [
    ../../core
    ../../core/virtualisation.nix

    ../../hardware/hajimaru
    ./hardware-configuration.nix
    nixos-hardware.framework

    ../../graphics
    ../../graphics/gnome.nix

    ../../users/mbund
  ];

  networking.hostName = "kumitate";

  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true;

  programs.wireshark.enable = true;
  programs.adb.enable = true;
  services.fwupd.enable = true;
  # hardware.video.hidpi.enable = lib.mkDefault true;
  # services.xserver.dpi = 200;

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.max-jobs = 16;
  nix.settings.system-features = ["benchmark" "nixos-test" "big-parallel" "kvm"];

  # age.secrets.rootPassword.file = ./root-password.age;
  # users.users.root.passwordFile = config.age.secrets.rootPassword.path;
  users.users.root.password = "root";
}
