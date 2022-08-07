{
  self,
  deploy-rs,
  nixpkgs,
  ...
}: let
  inherit (nixpkgs) lib;
  hosts = (import ./hosts.nix).all;

  genNode = hostName: nixosCfg: let
    inherit (hosts.${hostName}) address localSystem;
    inherit (deploy-rs.lib.${localSystem}) activate;

    defaults = {
      sshUser ? null,
      sudo ? null,
      ...
    }: {inherit sshUser sudo;};
  in
    (defaults hosts.${hostName})
    // {
      hostname = address;
      profiles.system.path = activate.nixos nixosCfg;
    };
in {
  user = "root";
  sudo = "doas -u";
  nodes = lib.mapAttrs genNode self.nixosConfigurations;
}
