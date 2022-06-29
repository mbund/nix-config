# hajimaru
The most common hardware configuration for my systems, with the root
partitioned as btrfs with specific subvolumes and snapshots, rolling
back on each boot.

| subvolume | mountpoint | persisted  | back up?         | description                               |
| --------- | ---------- | ---------- | ---------------- | ----------------------------------------- |
| root      | /          | no         | shouldn't        | root filesystem                           |
| home      | /home      | optionally | should           | user homes                                |
| nix       | /nix       | yes        | shouldn't        | trivial reconstructable                   |
| persist   | /persist   | yes        | maybe some files | select data from non-persisted subvolumes |
| log       | /var/log   | yes        | if you want      | system logs                               |
| swap      | /swap      | yes        | shouldn't        | dedicated for swapfile                    |

The subvolumes `root` and `home` correspond to the `root-blank` and
`home-blank` snapshots, which are simply empty filesystems.

