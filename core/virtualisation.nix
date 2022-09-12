{pkgs, ...}: {
  environment.systemPackages = with pkgs; [virt-manager spice-gtk swtpm];
  security.polkit.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  virtualisation.libvirtd.qemu.ovmf.packages = with pkgs; [OVMFFull];
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.lxd.enable = true;

  virtualisation.podman.enable = true;
  # virtualisation.docker.enable = true;
}
