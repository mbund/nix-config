{ pkgs, ... }:
{
  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      # nvidiaPersistenced = true;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
      driSupport32Bit = true;
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];

    deviceSection = ''
      Option "AllowSHMPixmaps" "on"
      Option "DRI3" "on"
    '';
  };

  virtualisation.docker.enableNvidia = true;
  virtualisation.podman.enableNvidia = true;
}
