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

# POSIX Compliance
HOME_DIR=$(getent passwd "$(id -un)" | cut -d: -f6)
DAEMON_DIR="$HOME_DIR/spotify-playerctl-helper"
DAEMON_LOC="$DAEMON_DIR/daemon.sh"
SERVICE_LOC="$HOME_DIR/.config/systemd/user/spotify-playerctl-helper.service"

echo "[INFO] Cleaning up the installation..."

# Remove the daemon directory and its contents if it exists
if [ -d "$DAEMON_DIR" ]; then
    echo "[INFO] Removing directory $DAEMON_DIR"
    rm -rf "$DAEMON_DIR" || { echo "[ERROR] Failed to remove $DAEMON_DIR"; exit 1; }
else
    echo "[INFO] Directory $DAEMON_DIR does not exist."
fi

# Remove the service file if it exists
if [ -f "$SERVICE_LOC" ]; then
    echo "[INFO] Removing service file $SERVICE_LOC"
    rm -f "$SERVICE_LOC" || { echo "[ERROR] Failed to remove $SERVICE_LOC"; exit 1; }
else
    echo "[INFO] Service file $SERVICE_LOC does not exist."
fi

echo "[INFO] Cleanup completed."
