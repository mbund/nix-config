{ config, pkgs, ... }: {
  imports = [
    ../../core

    ../../dev
    ../../dev/virt-manager.nix

    ../../hardware/efi.nix
    ../../hardware/nvidia.nix
    ../../hardware/bluetooth.nix

    ../../users/mbund

    ./state.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/mapper/nixos-root";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

    "/nix" = {
      device = "/dev/mapper/nixos-root";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    "/var/log" = {
      device = "/dev/mapper/nixos-root";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/persist" = {
      device = "/dev/mapper/nixos-root";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/mapper/nixos-root";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/UEFI-ESP";
      fsType = "vfat";
    };

    "/swap" = {
      device = "/dev/mapper/nixos-root";
      fsType = "btrfs";
      options = [ "subvol=swap" "compress=none" "noatime" ];
    };
  };

  swapDevices = [
    {
      # To initialize a new swapfile on btrfs, you must first create it like so
      # truncate -s /swap/swapfile
      # chattr +C /swap/swapfile
      # btrfs property set /swap/swapfile compression none
      device = "/swap/swapfile";
      size = 20 * 1024;
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

  boot.initrd.postDeviceCommands =
    let
      device = "/dev/mapper/nixos-root";
      subvolume = "root";
      rollback-snapshot = "root-blank";
    in
    pkgs.lib.mkBefore ''
      # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html

      mkdir -p /mnt
      mount -o subvol=/ ${device} /mnt

      btrfs subvolume list -o /mnt/${subvolume} |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done &&
      echo "deleting /${subvolume} subvolume..." &&
      btrfs subvolume delete /mnt/${subvolume}

      echo "restoring blank /${subvolume} subvolume..."
      btrfs subvolume snapshot /mnt/${rollback-snapshot} /mnt/${subvolume}

      umount /mnt
    '';

  networking.hostName = "kuro";
  networking.networkmanager.enable = true;

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

  services.fstrim.enable = true;
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/"
      "/nix"
      "/persist"
      "/var/log"
      "/home"
    ];
    interval = "monthly";
  };

  time.timeZone = "America/New_York";

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  age.secrets.rootPassword.file = ./root-password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;
}
