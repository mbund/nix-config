{
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}: {
  imports = [
    nixos-hardware.framework
    ../../hardware/intel.nix
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_19;
  zramSwap.enable = true;
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

  networking.interfaces.wlp166s0.useDHCP = true;

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

  boot.supportedFilesystems = ["ntfs"];

  services.fstrim.enable = true;
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.fileSystems = [
    "/"
    "/nix"
  ];

  programs.fuse.userAllowOther = true;
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
    directories = [
      "/var/log"

      "/var/lib/fprint"
    ];
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

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.timeout = 0;

  environment.systemPackages = with pkgs; [
    # one time reboot with 10 second timeout in the boot loader menu
    (writeShellScriptBin "reboot-to-menu" "systemctl reboot --boot-loader-menu=10")
  ];

  boot.resumeDevice = "/dev/mapper/root";
  systemd.sleep.extraConfig = "HibernateDelaySec=30m";
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.extraConfig = ''
    HandlePowerKey=suspend-then-hibernate
    IdleAction=suspend-then-hibernate
    IdleActionSec=2m
  '';

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
  boot.blacklistedKernelModules = ["hid_sensor_hub"]; # fix brightness keys on 12th gen intel framework

  # get the resume offset with
  # filefrag -v /swap/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}'
  boot.kernelParams = ["mem_sleep_default=deep" "resume_offset=8960946"];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
