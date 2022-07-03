# hajimaru
The most common hardware configuration for my systems including
state erausre. Btrfs is used mostly for its transparent compression,
which is useful for the nix store.

- `/` is a tmpfs partition
- `/nix` is a LUKS encrypted btrfs partition.
- `/nix/persist` is a btrfs subvolume for explicitly set data to persist across reboots
- `/nix/swap` is a btrfs subvolume for holding the swapfile (CoW disabled)
