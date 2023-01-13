[![NixOS](https://img.shields.io/badge/NixOS-unstable-9cf.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)
![License](https://img.shields.io/github/license/mbund/nixos-config?color=dgreen&style=flat-square)

## setup

Look over the commands in an [install.sh](hosts/kumitate/install.sh) and execute them one by one. To decrypt secrets follow the following rough instructions:

- Copy over `/etc/ssh/ssh_host_*` to `/state/etc/ssh/ssh_host_*`
- Add the `/etc/ssh/ssh_host_ed25519_key.pub` key and ip address to `nix/hosts.nix`
- Generate password with `mkpasswd -m sha-512` and make a secret with `agenix -e my/path/to/secret`
- Rekey all secrets with `agenix -r`

```
nixos-install --no-root-password
```

## deploy

You can also use [deploy-rs](https://github.com/serokell/deploy-rs) to deploy remotely.

## also check out

- [lovesegfault/nix-config](https://github.com/lovesegfault/nix-config)
- [notusknot/dotfiles-nix](https://github.com/notusknot/dotfiles-nix)
