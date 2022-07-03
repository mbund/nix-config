{ lib, ... }:
{
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "defaults" "noatime" "size=2g" "mode=755" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/nix";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/nix/persist" = {
    device = "/dev/mapper/nix";
    fsType = "btrfs";
    options = [ "subvol=@persist" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/nix/swap" = {
    device = "/dev/mapper/nix";
    fsType = "btrfs";
    options = [ "subvol=@swap" "compress=none" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  boot.initrd.luks.devices.nix = {
    device = "/dev/disk/by-label/nix";

    # WARNING: Leaks some metadata, see cryptsetup man page for --allow-discards.
    allowDiscards = true;

    # Set your own key with:
    # cryptsetup luksChangeKey /dev/disk/by-label/nix --key-file=/dev/zero --keyfile-size=1
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
