# Run each command individually to avoid issues with the filesystem syncing
dev=/dev/nvme0n1

set -ex

sgdisk --zap-all $dev
sgdisk -n 0:0:+1GiB -c 0:boot -t 0:ef00 $dev
mkfs.vfat -F 32 -n boot /dev/disk/by-partlabel/boot
sgdisk -n 0:0:0 -c 0:root $dev
cryptsetup luksFormat --type=luks2 --label=root /dev/disk/by-partlabel/root
cryptsetup luksOpen /dev/disk/by-partlabel/root root
mkfs.btrfs /dev/mapper/root
mount /dev/mapper/root /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/swap
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
btrfs subvolume snapshot -r /mnt/home /mnt/home-blank
umount /mnt
mount -o subvol=root,compress=zstd,noatime /dev/mapper/root /mnt
mkdir -p /mnt/{boot,nix,home,swap}
mount /dev/disk/by-label/boot /mnt/boot
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/root /mnt/nix
mount -o subvol=home,compress=zstd,noatime /dev/mapper/root /mnt/home
mount -o subvol=swap,compress=none,noatime /dev/mapper/root /mnt/swap
truncate -s 0 /mnt/swap/swapfile
chattr +C /mnt/swap/swapfile
nixos-generate-config
# nixos-install --no-root-password