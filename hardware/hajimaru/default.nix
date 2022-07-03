{ lib, ... }:
{
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "defaults" "noatime" "size=2g" "mode=755" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/nix/swap" = {
    # truncate -s 0 /nix/swap/swapfile
    # chattr +C /nix/swap/swapfile
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=swap" "compress=none" "noatime" ];
  };

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-label/root";

    # WARNING: Leaks some metadata, see cryptsetup man page for --allow-discards.
    allowDiscards = true;

    # Set your own key with:
    # cryptsetup luksChangeKey /dev/disk/by-label/root --key-file=/dev/zero --keyfile-size=1
    # You can then delete the rest of this block.
    keyFile = lib.mkDefault "/dev/zero";
    keyFileSize = lib.mkDefault 1;

    fallbackToPassword = true;
  };

  services.fstrim.enable = true;
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/nix"
    ];
    interval = "monthly";
  };
}
