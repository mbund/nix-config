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

  environment.systemPackages = with pkgs; [intel-gpu-tools];
}
