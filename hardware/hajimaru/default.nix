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
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/state" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=state" "compress=zstd" "noatime" ];
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

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-label/root";

    # WARNING: Leaks some metadata, see cryptsetup man page for --allow-discards.
    allowDiscards = true;

    # Set your own key with:
    # cryptsetup luksChangeKey /dev/disk/by-label/nix --key-file=/dev/zero --keyfile-size=1
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
      "/state"
      "/var/log"
      "/swap"
    ];
    interval = "monthly";
  };

  console.earlySetup = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 15;
      netbootxyz.enable = true;
    };
    timeout = 0;
  };

  boot.initrd.postDeviceCommands =
    let
      # recursively delete all subvolumes under `subvolume` and roll back
      # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
      rollback = device: subvolume: rollback-snapshot: ''
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
    in
    lib.mkBefore ''
      ${rollback "/dev/mapper/root" "home" "home-blank"}
      ${rollback "/dev/mapper/root" "root" "root-blank"}
    '';

  age.identityPaths = [ "/state/etc/ssh/ssh_host_ed25519_key" ];
  environment.persistence."/state" = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
