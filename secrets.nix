let
  inherit (builtins) attrNames attrValues mapAttrs listToAttrs;

  mbund = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoCC3KxKWWjz0DAmMYEJwRlVThavgKCc8eyQyaI2usE";

  hostPubkeys = mapAttrs (_: v: v.pubkey) (import ./nix/hosts.nix).nixos.all;

  allHostSecret = secretName:
    listToAttrs (
      map
        (host: {
          name = "hosts/${host}/${secretName}.age";
          value.publicKeys = [ mbund hostPubkeys.${host} ];
        })
        (attrNames hostPubkeys)
    );
in
with hostPubkeys;
{
  "users/mbund/password.age".publicKeys = [ mbund ] ++ (attrValues hostPubkeys);
} // allHostSecret "root-password"
