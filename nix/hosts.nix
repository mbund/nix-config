let
  hosts = {
    kodai = {
      type = "nixos";
      address = "192.168.1.112";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHX4bIFPseNuAD5A8REjuMmABWjCtwPlrH+P+jnN9aL";
    };

    # kuro = {
    #   type = "nixos";
    #   address = "192.168.1.115";
    #   localSystem = "x86_64-linux";
    #   pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/feNVmmwVYinqCOXGIYFb+pTRLvAL+JuW1NBGLA3qS";
    # };
  };

  inherit (builtins) attrNames concatMap listToAttrs;

  filterAttrs = pred: set:
    listToAttrs (concatMap (name: let value = set.${name}; in if pred name value then [{ inherit name value; }] else [ ]) (attrNames set));

  systemPred = system: (_: v: builtins.match ".*${system}.*" v.localSystem != null);

  genFamily = filter: hosts: rec {
    all = filterAttrs filter hosts;

    nixos = genFamily (_: v: v.type == "nixos") all;
    homeManager = genFamily (_: v: v.type == "home-manager") all;

    darwin = genFamily (systemPred "-darwin") all;
    linux = genFamily (systemPred "-linux") all;

    aarch64-darwin = genFamily (systemPred "aarch64-darwin") all;
    aarch64-linux = genFamily (systemPred "aarch64-linux") all;
    x86_64-darwin = genFamily (systemPred "x86_64-darwin") all;
    x86_64-linux = genFamily (systemPred "x86_64-linux") all;
  };
in
genFamily (_: _: true) hosts
