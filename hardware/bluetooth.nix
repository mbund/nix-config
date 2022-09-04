{pkgs, ...}: {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.disabledPlugins = ["sap"];
  hardware.bluetooth.settings = {
    General = {
      FastConnectable = "true";
      JustWorksRepairing = "always";
      MultiProfile = "multiple";
    };
  };

  hardware.pulseaudio.package = pkgs.pulseaudio.override {bluetoothSupport = true;};
  hardware.pulseaudio.extraModules = with pkgs; [pulseaudio-modules-bt];
  hardware.pulseaudio.extraConfig = ''
    load-module module-bluetooth-discover
    load-module module-bluetooth-policy
    load-module module-switch-on-connect
  '';

  environment.persistence."/nix/state".directories = [
    "/var/lib/bluetooth"
    "/etc/bluetooth"
  ];
}
