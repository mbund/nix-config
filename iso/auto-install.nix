{ config, lib, modulesPath, install, system, nixpkgs, ... }: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix"
  ];
  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

  systemd.services.install = {
    description = "Bootstrap a NixOS installation";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "polkit.service" ];
    path = [ "/run/current-system/sw/" ];
    script = ''
      ${install.partitionScript}

      ${config.system.build.nixos-install}/bin/nixos-install \
        --system ${(nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./auto-install-configuration.nix
              install.hardware
            ];
          }).config.system.build.toplevel} \
        --no-root-passwd \
        --cores 0
          
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
