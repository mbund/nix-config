{
  imports = [
    ../../core

    ./hardware-configuration.nix
    ../../hardware/intel.nix
    ../../hardware/nvidia.nix

    ../../graphics
    ../../graphics/gnome.nix
    ../../graphics/gaming.nix

    ../../users/mbund
  ];

  networking.hostName = "kyoudai";

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.max-jobs = 16;
  nix.settings.system-features = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];

  services.upower.enable = true;
  services.auto-cpufreq.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  # age.secrets.rootPassword.file = ./root-password.age;
  # users.users.root.passwordFile = config.age.secrets.rootPassword.path;

  users.users.root.password = "root";
}
