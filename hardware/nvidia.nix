{pkgs, ...}: {
  boot.blacklistedKernelModules = ["nouveau"];

  hardware.nvidia.modesetting.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    nvidia-vaapi-driver
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.deviceSection = ''
    Option "AllowSHMPixmaps" "on"
    Option "DRI3" "on"
  '';

  virtualisation.docker.enableNvidia = true;
  virtualisation.podman.enableNvidia = true;
}
