{ lib, ... }:
{
  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=persist" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=log" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/swap" = {
    # To initialize a new swapfile on btrfs, you must first create it like so
    # truncate -s 0 /swap/swapfile
    # chattr +C /swap/swapfile
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
      "/"
      "/home"
      "/nix"
      "/persist"
      "/var/log"
    ];
    interval = "monthly";
  };

  boot.initrd.postDeviceCommands =
    let
      device = "/dev/mapper/root";
      subvolume = "root";
      rollback-snapshot = "root-blank";
    in
    lib.mkBefore ''
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

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };
}
