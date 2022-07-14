{ config, pkgs, ... }: {
  imports = [
    ../../core
    ../../core/virtualisation.nix

    ../../hardware/hajimaru
    ../../hardware/nvidia.nix
    ../../hardware/intel.nix

    ../../graphics
    ../../graphics/gnome.nix
    ../../graphics/gaming.nix

    ../../users/mbund
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_18;
  swapDevices = [{ device = "/swap/swapfile"; size = 4 * 1024; }];

  services.upower.enable = true;
  services.auto-cpufreq.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  services.xserver.layout = "us";
  # services.xserver.xkbVariant = "colemak_dh";
  services.xserver.xkbOptions = "caps:escape_shifted_capslock";
  console.useXkbConfig = true;

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

  age.secrets.rootPassword.file = ./root-password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
