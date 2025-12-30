#!/usr/bin/env bash

# Define the Source of Truth (XDG Path)
RESURRECT_FILE="$HOME/.config/tmux/resurrect/last"

# Resolve the Symlink to the actual file
REAL_TARGET=$(readlink -f "$RESURRECT_FILE")

# Guard Clause: Exit if the file doesn't exist yet
if [[ ! -f "$REAL_TARGET" ]]; then
    exit 0
fi

# Atomic Cleaning (Remove NixOS/Vim wrapper paths)
sed -i \
    -e "s| --cmd .*-vim-pack-dir||g" \
    -e "s|/etc/profiles/per-user/$USER/bin/||g" \
    -e "s|/home/$USER/.nix-profile/bin/||g" \
    "$REAL_TARGET"
