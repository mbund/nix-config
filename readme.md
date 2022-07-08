[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

## deploy
This nix configuration uses [deploy-rs](https://github.com/serokell/deploy-rs)

Deploy to all hosts with
```
deploy
```
(available in the `nix develop` environment).

## setup
This is a two stage setup process which will create a small generation 1 NixOS installation
which then you can deploy onto.

Benefits of a two stage deploy
- A directly `deploy` onto a live iso can run out of storage space, because the size of the
image is a simple tmpfs using 50% of system RAM
- Having an image to roll back to in case of an error on deploy so you don't have to plug a
usb device back in

### stage 1 (autoinstall)
From any nixos live iso run the folling invocation, replacing `/dev/sda` with the drive that
you want to COMPLETELY OVERWRITE EVERYTHING ON. It requires the device to be UEFI bootable.
```
sudo nix --experimental-features "nix-command flakes" run github:mbund/nix-config#hajimaru-installer -- /dev/nvme0n1
```

Or you build the autoinstaller iso which will automatically detect a main drive and do a
completely unattended and offline install. Beware that it will erase everything on the
main drive and the motherboard must support UEFI booting.
```
nix build github:mbund/nix-config#hajimaru-autoinstall-iso
```

### stage 2
Just [deploy](#deploy)!

## also check out
- [lovesegfault/nix-config](https://github.com/lovesegfault/nix-config)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
