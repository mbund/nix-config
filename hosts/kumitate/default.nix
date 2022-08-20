{pkgs, ...}: {
  imports = [
    ../../core
    ../../core/virtualisation.nix

    ./hardware-configuration.nix

    ../../graphics
    ../../graphics/gnome.nix

    ../../users/mbund
  ];

  networking.hostName = "kumitate";

  environment.etc."NetworkManager/dispatcher.d/10-tzupdate".source = pkgs.writeScript "10-tzupdate" ''
    ${pkgs.tzupdate}/bin/tzupdate -z /etc/zoneinfo -d /dev/null
  '';

  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;

  programs.wireshark.enable = true;
  programs.adb.enable = true;
  virtualisation.waydroid.enable = true;
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

  environment.persistence."/nix/state".directories = [
    "/var/lib/waydroid"
  ];
}
