{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_19;
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8 * 1024;
    }
  ];

  services.xserver.layout = "us";
  # services.xserver.xkbVariant = "colemak_dh";
  services.xserver.xkbOptions = "caps:escape_shifted_capslock";
  console.useXkbConfig = true;

  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd" "noatime"];
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/swap" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = ["subvol=swap" "compress=none" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-label/root";
    allowDiscards = true;

    keyFile = "/dev/zero";
    keyFileSize = 1;

    fallbackToPassword = true;
  };

  services.fstrim.enable = true;
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.fileSystems = [
    "/"
    "/nix"
    "/swap"
  ];

  age.identityPaths = ["/nix/state/etc/ssh/ssh_host_ed25519_key"];
  environment.persistence."/nix/state" = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    # directories = [
    #   "/var/log"
    # ];
  };

  boot.initrd.postDeviceCommands = let
    # recursively delete all subvolumes under `subvolume` and roll back
    # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
    rollback = device: subvolume: rollback-snapshot: ''
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
  in
    lib.mkBefore ''
      ${rollback "/dev/mapper/root" "root" "root-blank"}
    '';

  boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.devices = ["nodev"];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.grub.configurationLimit = 10;
  # boot.loader.grub.extraEntries = ''
  #   menuentry "Windows" {
  #     insmod part_gpt
  #     insmod fat
  #     insmod search_fs_uuid
  #     insmod chain
  #     search --fs-uuid --set=root $FS_UUID
  #     chainloader /EFI/Microsoft/Boot/bootmgfw.efi
  #   }
  # '';

  boot.resumeDevice = "/dev/mapper/root";
  systemd.sleep.extraConfig = "HibernateDelaySec=2h";
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.extraConfig = ''
    HandlePowerKey=suspend-then-hibernate
    IdleAction=suspend-then-hibernate
    IdleActionSec=2m
  '';

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod"];
  # boot.kernelParams = ["mem_sleep_default=deep" "resume_offset="];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
