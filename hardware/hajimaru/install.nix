{ pkgs, ... }:
{
  partitionScript = pkgs.writeShellApplication {
    name = "install";
    runtimeInputs = with pkgs; [
      cryptsetup
    ];
    text = builtins.readFile ./install.sh;
  };

  hardware = import ./default.nix;
}
