{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    virt-manager
    spice-gtk
    swtpm
    docker-compose
  ];
  security.polkit.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
}
