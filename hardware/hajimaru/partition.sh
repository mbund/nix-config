dev=$1

if [ -z "$dev" ]; then
  echo "Device must be set, ex: /dev/nvme0n1"
  exit 1
fi

set -ex

wait_for () {
  sleep 1
  for _ in seq 10; do
    if "$@"; then
      break
    fi
    sleep 1
  done
}

# https://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_type_GUIDs
sfdisk --wipe=always $dev << EOF
  label: gpt

  name=boot, size=2GiB, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B
  name=root
EOF
sync

wait_for [ -b /dev/disk/by-partlabel/boot ]
sync
mkfs.vfat -F 32 -n boot /dev/disk/by-partlabel/boot
sync

# encrypt root btrfs partition, with a default key of a single null byte
wait_for [ -b /dev/disk/by-partlabel/root ]
sync
cryptsetup luksFormat --batch-mode --type=luks2 --label=root /dev/disk/by-partlabel/root /dev/zero --keyfile-size=1
cryptsetup luksOpen --batch-mode /dev/disk/by-partlabel/root root --key-file=/dev/zero --keyfile-size=1
sync
mkfs.btrfs -L root /dev/mapper/root
sync

# create btrfs subvolumes and empty snapshots
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

# mount boot
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# create swapfile
mkdir -p /mnt/swap
mount -o subvol=swap,compress=none,noatime /dev/mapper/root /mnt/swap
truncate -s 0 /mnt/swap/swapfile
chattr +C /mnt/swap/swapfile
