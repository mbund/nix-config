{ config, lib, pkgs, ... }:
{
  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/disk/by-label/cryptroot";
    allowDiscards = true;
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/vg/root";
  networking.hostId = "d51b3be5"; # head -c8 /etc/machine-id
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r tank/local/root@blank
    zfs rollback -r tank/local/home@blank
  '';
  fileSystems = {
    "/boot" = { device = "/dev/disk/by-label/boot"; fsType = "vfat"; };
    "/" = { device = "tank/local/root"; fsType = "zfs"; };
    "/nix" = { device = "tank/local/nix"; fsType = "zfs"; };
    "/home" = { device = "tank/local/home"; fsType = "zfs"; };
    "/state" = { device = "tank/safe/state"; fsType = "zfs"; neededForBoot = true; };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_18;
  swapDevices = [{ device = "/dev/vg/swap"; }];

  services.xserver.layout = "us";
  # services.xserver.xkbVariant = "colemak_dh";
  services.xserver.xkbOptions = "caps:escape_shifted_capslock";
  console.useXkbConfig = true;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
