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

  swapDevices = [
    {
      # To initialize a new swapfile on btrfs, you must first create it like so
      # truncate -s /swap/swapfile
      # chattr +C /swap/swapfile
      # btrfs property set /swap/swapfile compression none
      device = "/swap/swapfile";
      size = 4 * 1024;
    }
  ];

  boot.initrd.luks.devices = {
    "nixos-root" = {
      device = "/dev/disk/by-uuid/ad3f0a0f-93ac-40c6-a294-279c70347d4e";
    };
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "kuro";

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
    settings = {
      max-jobs = 16;
      system-features = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];
    };
  };

  time.timeZone = "America/New_York";

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  age.secrets.rootPassword.file = ./root-password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
