{pkgs, ...}: {
  environment.systemPackages = with pkgs; [virt-manager spice-gtk swtpm];
  security.polkit.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu = {
    package = pkgs.qemu_kvm;
    ovmf = {
      enable = true;
      packages = with pkgs; [OVMFFull];
    };
    swtpm.enable = true;
  };

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.lxd.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  environment.persistence."/state".directories = [
    "/var/lib/docker"
    "/var/lib/libvirt"
  ];
}
