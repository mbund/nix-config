{
  imports = [
    ../../core
    ../../core/virtualisation.nix

    ./hardware-configuration.nix
    ../../hardware/intel.nix

    ../../graphics
    ../../graphics/gnome.nix

    ../../users/mbund
  ];

  networking.hostName = "kyoudai";

  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true;

  programs.wireshark.enable = true;
  programs.adb.enable = true;

  virtualisation.waydroid.enable = true;
  virtualisation.lxd.enable = true;

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.max-jobs = 16;
  nix.settings.system-features = ["benchmark" "nixos-test" "big-parallel" "kvm"];

  # age.secrets.rootPassword.file = ./root-password.age;
  # users.users.root.passwordFile = config.age.secrets.rootPassword.path;
  users.users.root.password = "root";

  environment.persistence."/state".directories = [
    "/var/lib/waydroid"
  ];
}
