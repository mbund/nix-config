{pkgs, ...}: {
  services.hardware.openrgb.motherboard = "intel";

  boot.kernelModules = ["kvm_intel"];
  boot.kernelParams = ["intel_iommu=on"];
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options i915 enable_guc=3 enable_fbc=1 fastboot=1
  '';

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  environment.systemPackages = with pkgs; [intel-gpu-tools];
}
