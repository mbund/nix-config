{ lib, ... }:
{
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

  boot.initrd.postDeviceCommands =
    let
      device = "/dev/mapper/nixos-root";
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
}
