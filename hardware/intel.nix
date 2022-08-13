{
  pkgs,
  nixos-hardware,
  ...
}: {
  imports = [nixos-hardware.common-cpu-intel];

  boot.kernelModules = ["kvm_intel"];
  boot.kernelParams = ["intel_iommu=on"];
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options i915 enable_guc=3 enable_fbc=1 fastboot=1
  '';

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver # LIBVA_DRIVER_NAME=iHD
    vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    vaapiVdpau
    libvdpau-va-gl
  ];

  environment.systemPackages = with pkgs; [intel-gpu-tools];
}
