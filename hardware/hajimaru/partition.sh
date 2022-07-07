dev=$1

if [ -z "$dev" ]; then
  echo "Device must be set, ex: /dev/nvme0n1"
  exit 1
fi

if [ "$EUID" != 0 ]; then
  sudo "$0" "$@"
  exit $?
fi

wait_for () {
  sleep 1
  for _ in seq 10; do
    if "$@"; then
      break
    fi
    sleep 1
  done
}

set -ex

sgdisk --zap-all $dev

sgdisk -n 0:0:+2GiB -c 0:boot -t 0:ef00 $dev
wait_for [ -b /dev/disk/by-partlabel/boot ]
sync
mkfs.vfat -F 32 -n boot /dev/disk/by-partlabel/boot

sgdisk -n 0:0:0 -c 0:root $dev
wait_for [ -b /dev/disk/by-partlabel/root ]
sync
cryptsetup luksFormat --batch-mode --type=luks2 --label=root /dev/disk/by-partlabel/root /dev/zero --keyfile-size=1
cryptsetup luksOpen --batch-mode /dev/disk/by-partlabel/root root --key-file=/dev/zero --keyfile-size=1
sync

mkdir -p /mnt
mount /dev/mapper/root /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/swap
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
btrfs subvolume snapshot -r /mnt/home /mnt/home-blank
umount /mnt

mount -o subvol=root,compress=zstd,noatime /dev/mapper/root /mnt

mkdir -p /mnt/{home,nix,persist,var/log}
mount -o subvol=home,compress=zstd /dev/mapper/root /mnt/home
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/root /mnt/nix
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/root /mnt/persist
mount -o subvol=log,compress=zstd,noatime /dev/mapper/root /mnt/var/log

mkdir -p /mnt/swap
mount -o subvol=swap,compress=none,noatime /dev/mapper/root /mnt/swap
truncate -s 0 /mnt/swap/swapfile
chattr +C /mnt/swap/swapfile

mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot