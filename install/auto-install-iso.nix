{ config, lib, pkgs, modulesPath, installScript, ... }: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  isoImage.isoName = lib.mkForce "destructive-hajimaru-${config.isoImage.isoBaseName}-${pkgs.stdenv.hostPlatform.system}.iso";

  services.getty.helpLine = ''
    An UNATTENDED OFFLINE NixOS installation is about to begin.
    Installation will OVERWRITE ALL DATA IN 15 SECONDS.

    If this is not what you want POWEROFF IMMEDIATELY by
    running `poweroff` or `reboot`.

    All of /dev/sda /dev/nvme0n1 /dev/vda should be considered
    unsafe.

    In your bash history is a command you can use to view the
    systemd unit progress on the unattended installation.

    ALL DATA ON THE MAIN DISK WILL BE OVERWRITTEN IN 15 SECONDS
  '';

  systemd.services.install = {
    description = "Bootstrap a NixOS installation";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "polkit.service" ];
    path = [ "/run/current-system/sw/" ];
    script = ''
      echo "journalctl -fb -n 100 -u install" >> /home/nixos/.bash_history

      dev=/dev/sda
      [ -b /dev/nvme0n1 ] && dev=/dev/nvme0n1
      [ -b /dev/vda ] && dev=/dev/vda

      echo "30 seconds until overwriting everything on $dev" && sleep 5
      echo "25 seconds until overwriting everything on $dev" && sleep 5
      echo "20 seconds until overwriting everything on $dev" && sleep 5
      echo "15 seconds until overwriting everything on $dev" && sleep 5
      echo "10 seconds until overwriting everything on $dev" && sleep 5
      echo " 5 seconds until overwriting everything on $dev" && sleep 5

      ${installScript}/bin/install "$dev"

      reboot
    '';
    environment = config.nix.envVars // {
      inherit (config.environment.sessionVariables) NIX_PATH;
      HOME = "/root";
    };
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
