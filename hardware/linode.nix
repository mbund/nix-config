# 1. Create two (2) disk images:
#    - Installer: 1024mb
#    - NixOS: rest
#
# 2. Boot in rescue mode with:
#    - /dev/sda -> Installer
#    - /dev/sdb -> NixOS
#
# 3. Once booted into Finnix (step 2) run these commands:
#      update-ca-certificates
#      iso=https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
#      curl -L $iso | tee >(dd of=/dev/sda) | sha256sum
#
# 4. Create two configuration profiles:
#    - Installer
#      - Kernel: Direct Disk
#      - /dev/sda -> NixOS
#      - /dev/sdb -> Installer
#      - Root Device -> /dev/sdb
#      - Helpers: distro and auto network helpers = off
#      - Leave others on their defaults
#    - Boot
#      - Kernel: GRUB 2
#      - /dev/sda -> NixOS
#      - Helpers: distro and auto network helpers = off
#      - Leave others on their defaults
#
# 5. Boot into installer profile.
#
# 6. Install NixOS:
#    - ???
#    - PROFIT!!!
#
# 8. Reboot into "Boot" profile.

{ pkgs, config, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardened-server-kernel.nix
  ];

  fileSystems."/" = {
    device = "/dev/sda";
    fsType = "ext4";
  };

  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_scsi" "ahci" "sd_mod" ];
  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  boot.loader.timeout = 10;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.forceInstall = true;

  networking.usePredictableInterfaceNames = false;
  networking.interfaces.eth0.useDHCP = true;

  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat
  ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
