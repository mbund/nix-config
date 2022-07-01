{ config, pkgs, ... }: {
  imports = [
    ../../core

    ../../dev
    ../../dev/virt-manager.nix

    ../../hardware/hajimaru
    ../../hardware/efi.nix
    ../../hardware/nvidia.nix
    ../../hardware/intel.nix
    ../../hardware/bluetooth.nix

    ../../graphics
    ../../graphics/hyprland.nix
    ../../graphics/gaming.nix

    ../../users/mbund

    ./state.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  swapDevices = [{ device = "/swap/swapfile"; size = 4 * 1024; }];

  services.tlp.enable = true;
  services.upower.enable = true;
  services.auto-cpufreq.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  networking.hostName = "kodai";
  networking.interfaces.enp3s0f1.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.max-jobs = 16;
  nix.settings.system-features = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];

  time.timeZone = "America/New_York";

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  #age.secrets.rootPassword.file = ./root-password.age;
  #users.users.root.passwordFile = config.age.secrets.rootPassword.path;
  users.users.root.password = "root";
}
