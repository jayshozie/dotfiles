#!/usr/bin/env bash
# Copyright (C)  2026  Emir Baha YILDIRIM
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
