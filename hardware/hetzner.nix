# #!/bin/sh
# curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | doNetConf=y NIX_CHANNEL=nixos-22.05 bash 2>&1 | tee /tmp/infect.log
{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardened-server-kernel.nix
  ];

  networking = {
    nameservers = [ "8.8.8.8" ];
    defaultGateway.address = "172.31.1.1";
    defaultGateway6 = { address = "fe80::1"; interface = "eth0"; };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "5.161.125.12"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2a01:4ff:f0:ca64::1"; prefixLength = 64; }
          { address = "fe80::9400:1ff:fe70:559"; prefixLength = 64; }
        ];
        ipv4.routes = [{ address = "172.31.1.1"; prefixLength = 32; }];
        ipv6.routes = [{ address = "fe80::1"; prefixLength = 128; }];
      };
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="96:00:01:70:05:59", NAME="eth0"  
  '';

  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];

  zramSwap.enable = true;
  services.openiscsi.name = "iqn.2016-04.com.open-iscsi:be1288137ee";
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
}
