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
  name=nix
EOF
sync

wait_for [ -b /dev/disk/by-partlabel/boot ]
sync
mkfs.vfat -F 32 -n boot /dev/disk/by-partlabel/boot
sync

# encrypt nix btrfs partition, with a default key of a single null byte
wait_for [ -b /dev/disk/by-partlabel/nix ]
sync
cryptsetup luksFormat --batch-mode --type=luks2 --label=nix /dev/disk/by-partlabel/nix /dev/zero --keyfile-size=1
cryptsetup luksOpen --batch-mode /dev/disk/by-partlabel/nix nix --key-file=/dev/zero --keyfile-size=1
sync
mkfs.btrfs -L nix /dev/mapper/nix
sync

# mount tmpfs as root
mount -t tmpfs none /mnt

# mount boot
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# mount nix
mkdir -p /mnt/nix
mount -t btrfs /dev/mapper/nix /mnt/nix
btrfs subvolume create /mnt/nix/root
btrfs subvolume create /mnt/nix/store
btrfs subvolume create /mnt/nix/persist
btrfs subvolume create /mnt/nix/swap
umount /mnt/nix

mount -o subvol=root,compress=zstd,noatime /dev/mapper/nix /mnt/nix
mkdir -p /mnt/nix/{store,persist}
mount -o subvol=root,compress=zstd,noatime /dev/mapper/nix /mnt/nix/store
mount -o subvol=root,compress=zstd,noatime /dev/mapper/nix /mnt/nix/persist

# create swapfile
mkdir -p /mnt/nix/swap
mount -o subvol=swap,compress=none,noatime /dev/mapper/nix /mnt/nix/swap
truncate -s 0 /mnt/nix/swap/swapfile
chattr +C /mnt/nix/swap/swapfile
