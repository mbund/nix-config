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

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_0;
  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = (32 + 2) * 1024;
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

  fileSystems."/home" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd" "noatime"];
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

    fallbackToPassword = true;
  };

  boot.supportedFilesystems = ["ntfs"];

  services.fstrim.enable = true;
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.fileSystems = [
    "/"
    "/nix"
  ];

  age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;

  environment.systemPackages = with pkgs; [
    # one time reboot with 10 second timeout in the boot loader menu
    (writeShellScriptBin "reboot-to-menu" "systemctl reboot --boot-loader-menu=10")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
  boot.blacklistedKernelModules = ["hid_sensor_hub"]; # fix brightness keys on 12th gen intel framework

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
