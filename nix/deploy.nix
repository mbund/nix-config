{ self
, deploy-rs
, nixpkgs
, ...
}:
let
  inherit (nixpkgs) lib;
  hosts = (import ./hosts.nix).all;

  genNode = hostName: nixosCfg:
    let
      inherit (hosts.${hostName}) address localSystem;
      inherit (deploy-rs.lib.${localSystem}) activate;
    in
    {
      hostname = address;
      profiles.system.path = activate.nixos nixosCfg;
    };
in
{
  user = "root";
  sudo = "doas -u";
  autoRollback = true;
  magicRollback = true;
  nodes = lib.mapAttrs genNode self.nixosConfigurations;
}
