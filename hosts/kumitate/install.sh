dev=/dev/nvme0n1

set -ex
sgdisk --zap-all $dev
sgdisk -n 0:0:+1GiB -c 0:boot -t 0:ef00 $dev
mkfs.vfat -F 32 -n boot /dev/disk/by-partlabel/boot
sgdisk -n 0:0:-128GiB -c 0:root $dev
cryptsetup luksFormat --batch-mode --type=luks2 --label=root /dev/disk/by-partlabel/root /dev/zero --keyfile-size=1
cryptsetup luksOpen --batch-mode /dev/disk/by-partlabel/root root --key-file=/dev/zero --keyfile-size=1
mkfs.btrfs /dev/mapper/root
mount /dev/mapper/root /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/swap
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
umount /mnt
mount -o subvol=root,compress=zstd,noatime /dev/mapper/root /mnt
mkdir -p /mnt/{boot,nix,swap}
mount /dev/disk/by-label/boot /mnt/boot
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/root /mnt/nix
mount -o subvol=swap,compress=none,noatime /dev/mapper/root /mnt/swap
truncate -s 0 /mnt/swap/swapfile
chattr +C /mnt/swap/swapfile
nixos-generate-config --root /mnt