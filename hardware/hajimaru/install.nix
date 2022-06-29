{ writeShellApplication
, cryptsetup
}:
writeShellApplication {
  name = "install";
  runtimeInputs = [
    cryptsetup
  ];
  text = builtins.readFile ./install.sh;
}
