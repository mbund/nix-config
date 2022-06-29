set -ex

wait_for () {
  for _ in seq 10; do
    if $@; then
      break
    fi
    sleep 1
  done
}

dev=/dev/sda
[ -b /dev/nvme0n1 ] && dev=/dev/nvme0n1
[ -b /dev/vda ] && dev=/dev/vda

# https://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_type_GUIDs
sfdisk --wipe=always $dev << EOF
  label: gpt

  name=boot, size=2GiB, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B
  name=root
EOF

wait_for [ -b /dev/disk/by-partlabel/boot ]
mkfs.ext4 -L boot /dev/disk/by-partlabel/boot

# encrypt root btrfs partition, with a default key of a single null byte
wait_for [ -b /dev/disk/by-partlabel/root ]
cryptsetup luksFormat --batch-mode --type=luks2 --label=root /dev/disk/by-partlabel/root /dev/zero --keyfile-size=1
cryptsetup luksOpen --batch-mode /dev/disk/by-partlabel/root root --key-file=/dev/zero --keyfile-size=1
mkfs.btrfs -L root /dev/mapper/root

# create subvolumes
mkdir -p /mnt
mount /dev/mapper/root /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/swap

# create blank snapshots
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
btrfs subvolume snapshot -r /mnt/home /mnt/home-blank
umount /mnt

# remount root subvolume and add required subvolumes
mount -o subvol=root,compress=zstd,noatime /dev/mapper/root /mnt
mkdir -p /mnt/{home,nix,persist,var/log}
mount -o subvol=home,compress=zstd /dev/mapper/root /mnt/home
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/root /mnt/nix
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/root /mnt/persist
mount -o subvol=log,compress=zstd,noatime /dev/mapper/root /mnt/var/log

# create swapfile
mkdir -p /mnt/swap
mount -o subvol=swap,compress=none,noatime /dev/mapper/root /mnt/swap
truncate -s 0 /mnt/swap/swapfile
chattr +C /mnt/swap/swapfile

# mount bootloader
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

nixos-generate-config --dir /root
