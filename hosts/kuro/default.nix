{ config, pkgs, ... }: {
  imports = [
    ../../core

    ../../dev
    ../../dev/virt-manager.nix

    ../../hardware/hajimaru
    ../../hardware/efi.nix
    ../../hardware/nvidia.nix
    ../../hardware/bluetooth.nix

    ../../graphics
    ../../graphics/hyprland.nix
    ../../graphics/gaming.nix

    ../../users/mbund

    ./state.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  swapDevices = [{ device = "/swap/swapfile"; size = 4 * 1024; }];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  networking.hostName = "kuro";

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.max-jobs = 16;
  nix.settings.system-features = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];

  time.timeZone = "America/New_York";

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  age.secrets.rootPassword.file = ./root-password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
