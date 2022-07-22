let
  hosts = {
    kodai = {
      type = "nixos";
      address = "100.86.8.121";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCXxKk/l/+A4xbYcYsyHPRuvBD70yf76vHGokfDFIwn";
    };

    kuro = {
      type = "nixos";
      address = "100.115.127.107";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYbI8KHg/IjWijggQK8q9PV65PsHt82QsQtCOOag2Mp";
    };
  };

  inherit (builtins) attrNames concatMap listToAttrs;

  filterAttrs = pred: set:
    listToAttrs (concatMap (name: let value = set.${name}; in if pred name value then [{ inherit name value; }] else [ ]) (attrNames set));

  systemPred = system: (_: v: builtins.match ".*${system}.*" v.localSystem != null);

  genFamily = filter: hosts: rec {
    all = filterAttrs filter hosts;

    nixos = genFamily (_: v: v.type == "nixos") all;
    homeManager = genFamily (_: v: v.type == "home-manager") all;

    linux = genFamily (systemPred "-linux") all;

    aarch64-linux = genFamily (systemPred "aarch64-linux") all;
    x86_64-linux = genFamily (systemPred "x86_64-linux") all;
  };
in
genFamily (_: _: true) hosts
