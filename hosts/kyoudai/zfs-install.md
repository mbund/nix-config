# Install NixOS on ZFS With Opt-In State

## Partitioning strategy
```
nvme0n1
├─nvme0n1p1    BOOT
└─nvme0n1p2    LUKS CONTAINER
  └─cryptroot  LUKS MAPPER
    └─vg-swap  SWAP
    └─vg-root  ZFS
```

## On target machine
```bash
# Enable sshd
sudo systemctl start sshd

# Set password
passwd

# Get IP address
ifconfig
```

## On bootstrapping machine
```bash
# SSH in
ssh nixos@192.168.1.XXX

# Become root
sudo su
```
```bash
# Create convenient alias for drive
DISK=/dev/disk/by-id/<id-goes-here>

# Clear disk
wipefs -af $DISK
sgdisk -Zo $DISK

# Create GPT partition table
parted $DISK -- mklabel gpt

# Create boot partition
parted $DISK -- mkpart ESP fat32 1MiB 512MiB
parted $DISK -- set 1 boot on

# Create root partition
parted $DISK -- mkpart primary 512MiB 100%

# Create LUKS container
cryptsetup luksFormat --batch-mode --type luks2 --label cryptroot --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --use-random $DISK-part2

# Open LUKS container
cryptsetup open $DISK-part2 cryptroot

# Set up LVM
pvcreate /dev/mapper/cryptroot
vgcreate vg /dev/mapper/cryptroot
lvcreate --name swap --size 16G vg
lvcreate --name root --extents '100%FREE' vg

# Enable swap
mkswap /dev/vg/swap
swapon /dev/vg/swap

# Format root volume as ZFS
zpool create -f -R /mnt -O mountpoint=none -O compression=zstd -O atime=off -O xattr=sa -O acltype=posixacl tank /dev/vg/root

# Create and mount root dataset
zfs create -p -o mountpoint=legacy tank/local/root
zfs snapshot tank/local/root@blank
mount -t zfs tank/local/root /mnt

# Format boot partition as FAT32
mkfs.vfat -F 32 -n boot $DISK-part1

# Mount boot partition
mkdir /mnt/boot
mount $DISK-part1 /mnt/boot

# Create and mount dataset for `/nix`
zfs create -p -o mountpoint=legacy tank/local/nix
mkdir /mnt/nix
mount -t zfs tank/local/nix /mnt/nix

# Create and mount dataset for `/home`
zfs create -p -o mountpoint=legacy tank/local/home
zfs snapshot tank/local/home@blank
mkdir /mnt/home
mount -t zfs tank/local/home /mnt/home

# Create and mount dataset for persisted state
zfs create -p -o mountpoint=legacy tank/safe/state
mkdir /mnt/state
mount -t zfs tank/safe/state /mnt/state

# Generate initial NixOS configuration
nixos-generate-config --root /mnt
```
