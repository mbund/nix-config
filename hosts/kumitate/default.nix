{pkgs, ...}: {
  imports = [
    ../../core
    ../../core/virtualisation.nix

    ./hardware-configuration.nix

    ../../graphics
    ../../graphics/hyprland.nix

    ../../users/mbund
  ];

  networking.hostName = "kumitate";

  environment.etc."NetworkManager/dispatcher.d/10-tzupdate".source = pkgs.writeScript "10-tzupdate" ''
    ${pkgs.tzupdate}/bin/tzupdate -z /etc/zoneinfo -d /dev/null
  '';

  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;
  services.tlp.enable = true;
  services.tlp.settings = {
    PCIE_ASPM_ON_BAT = "powersupersave";
    RUNTIME_PM_ON_BAT = "auto";
  };

  programs.steam.enable = true;
  programs.wireshark.enable = true;
  programs.adb.enable = true;
  virtualisation.waydroid.enable = true;
  services.fwupd.enable = true;
  services.fprintd.enable = true;

  security.pam.yubico.enable = true;
  security.pam.yubico.mode = "challenge-response";

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.max-jobs = 16;
  nix.settings.system-features = ["benchmark" "nixos-test" "big-parallel" "kvm"];

  users.users.root.password = "root";

  environment.persistence."/nix/state".directories = [
    "/var/lib/waydroid"
  ];
}
