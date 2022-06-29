{ writeShellApplication
, cryptsetup
}:
writeShellApplication {
  name = "partition";
  runtimeInputs = [
    cryptsetup
  ];
  text = builtins.readFile ./partition.sh;
}
