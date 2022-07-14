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
      inherit (hosts.${hostName}) address localSystem sshUser;
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
  nodes = lib.mapAttrs genNode self.nixosConfigurations;
}
