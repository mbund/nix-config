let
  inherit (builtins) attrNames attrValues mapAttrs listToAttrs;

  mbund = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoCC3KxKWWjz0DAmMYEJwRlVThavgKCc8eyQyaI2usE";

  hosts = mapAttrs (_: v: v.pubkey) (import ./nix/hosts.nix).nixos.all;

  allHostSecret = secretName:
    listToAttrs (
      map
        (host: {
          name = "hosts/${host}/${secretName}.age";
          value.publicKeys = [ mbund hosts.${host} ];
        })
        (attrNames hosts)
    );
in
with hosts;
{
  "users/mbund/password.age".publicKeys = [ mbund ] ++ (attrValues hosts);
} // allHostSecret "root-password"
