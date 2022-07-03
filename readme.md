[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

Heavily inspired by [lovesegfault/nix-config](https://github.com/lovesegfault/nix-config)

## deploy
This nix configuration uses [deploy-rs](https://github.com/serokell/deploy-rs)

Deploy to all hosts with
```
deploy
```
(available in the `nix develop` environment).

## setup
From any nixos live iso run the folling invocation, replacing `/dev/sda` with the drive that
you want to COMPLETELY OVERWRITE EVERYTHING ON. It requires the device to be UEFI bootable.
```
sudo nix --experimental-features "nix-command flakes" run github:mbund/nix-config#hajimaru-install -- /dev/sda
```

Or you build the autoinstaller iso which will automatically detect a main drive and
do a completely unattended and offline install with it.
```
nix build github:mbund/nix-config#hajimaru-autoinstall-iso
```

Both of these methods will install a bootstrapping environment, or rather a generation 1
of a NixOS install. This is so that you can copy over required ssh keys to perform
the final [deploy](#deploy).

Any other method of installing will work too, as long as at the end you can successfully
[deploy](#deploy) to it.