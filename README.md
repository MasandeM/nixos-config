# nixos-config

## Fresh install setup

1. Install NixOS with default config
2. Run:
```bash
nix-shell -p git curl --run "bash <(curl -s https://raw.githubusercontent.com/MasandeM/nixos-config/main/setup.sh)"
