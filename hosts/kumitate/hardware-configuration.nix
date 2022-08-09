{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_19;
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 4 * 1024;
    }
  ];
}
