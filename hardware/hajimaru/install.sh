dev=/dev/sda
[ -b /dev/nvme0n1 ] && dev=/dev/nvme0n1
[ -b /dev/vda ] && dev=/dev/vda

# https://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_type_GUIDs
sfdisk --wipe=always $dev << EOF
  label: gpt

  name=boot, size=2GiB, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B
  name=nixos
EOF

mkfs.vfat -F 32 -n boot /dev/disk/by-partlabel/boot

cryptsetup luksFormat --type=luks2 --label=root /dev/disk/by-partlabel/nixos /dev/zero --keyfile-size=1
cryptsetup luksOpen /dev/disk/by-partlabel/nixos root --key-file=/dev/zero --keyfile-size=1
mkfs.ext4 -L nixos /dev/mapper/root
mount /dev/mapper/root /mnt

mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
