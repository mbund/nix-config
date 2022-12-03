# #!/bin/sh
# curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | doNetConf=y NIX_CHANNEL=nixos-22.11 bash 2>&1 | tee /tmp/infect.log
{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardened-server-kernel.nix
  ];

  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
  boot.initrd.kernelModules = ["nvme"];

  zramSwap.enable = true;
  services.openiscsi.name = "iqn.2016-04.com.open-iscsi:be1288137ee";
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
