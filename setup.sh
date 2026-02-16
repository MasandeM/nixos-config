#!/bin/bash
# setup.sh - Bootstrap NixOS config on a new machine

# Generate hardware config for this specific machine
sudo nixos-generate-config

# Clone your config
git clone https://github.com/MasandeM/nixos-config.git ~/.nixos-config

# Symlink your portable configs (not hardware-configuration.nix)
sudo ln -sf ~/.nixos-config/configuration.nix /etc/nixos/configuration.nix

# Rebuild
sudo nixos-rebuild switch
