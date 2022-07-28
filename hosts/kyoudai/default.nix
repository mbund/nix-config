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

  programs.wireshark.enable = true;

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
