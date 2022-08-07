{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../core
    ../../core/virtualisation.nix

    ../../hardware/hajimaru
    ../../hardware/nvidia.nix

    ../../graphics
    ../../graphics/gnome.nix
    ../../graphics/gaming.nix

    ../../users/mbund
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
  boot.kernelModules = ["kvm-amd"];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_18;
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 4 * 1024;
    }
  ];

  # run `iscsi-iname` in package `openiscsi`
  services.openiscsi.name = "iqn.2016-04.com.open-iscsi:cee2529c1bc2";

  services.xserver.layout = "us";
  # services.xserver.xkbVariant = "colemak_dh";
  services.xserver.xkbOptions = "caps:escape_shifted_capslock";
  console.useXkbConfig = true;

  services.flatpak.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  networking.hostName = "kuro";
  networking.interfaces.enp6s0.useDHCP = true;

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.max-jobs = 16;
  nix.settings.system-features = ["benchmark" "nixos-test" "big-parallel" "kvm"];

  time.timeZone = "America/New_York";

  age.secrets.rootPassword.file = ./root-password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;

  environment.persistence."/state".directories = [
    "/var/lib/flatpak"
  ];
}
