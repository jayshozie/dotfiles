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

# posix compliance
HOME_DIR=$(getent passwd "$(id -un)" | cut -d: -f6)
DAEMON_DIR="$HOME_DIR/spotify-playerctl-helper"
DAEMON_LOC="$DAEMON_DIR/daemon.sh"
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

if [[ ! -d $HOME_DIR/.config/systemd/user ]]; then
    echo "[ERROR] $HOME_DIR/.config/systemd/user does not exist"
    exit 1
fi

SERVICE_LOC="$HOME_DIR/.config/systemd/user/spotify-playerctl-helper.service"
echo "[INFO] Installing the script and service for '$(id -un)'."
read -p "Do you want to proceed? (y/n) " proceed_choice
if [[ $proceed_choice != [yY] ]]; then
    echo "Exiting..."
    exit 0
fi

echo "Proceeding..."
if [[ ! -d $DAEMON_DIR ]]; then
    echo "[INFO] Creating directory $DAEMON_DIR"
    mkdir -p "$DAEMON_DIR" || { echo "[ERROR] Failed to create directory $DAEMON_DIR"; exit 1; }
fi

echo "[INFO] Overwriting file $DAEMON_LOC"
cp -f "$SCRIPT_DIR/daemon.sh" "$DAEMON_LOC" || { echo "[ERROR] Failed to copy daemon.sh"; exit 1; }

if [[ -f "$SERVICE_LOC" ]]; then
    echo "The service file $SERVICE_LOC exists."
    read -p "Do you want to continue the installation? (y/n) " overwrite_choice
    if [[ $overwrite_choice != [yY] ]]; then
        echo "Exiting..."
        exit 0
    fi
fi

# Create and modify the service file
TMP_FILE="$SCRIPT_DIR/tmp"
sed "s/USER/$(id -un)/g" "$SCRIPT_DIR/spotify-playerctl-helper.service" > "$TMP_FILE" || { echo "[ERROR] Failed to create tmp service file"; exit 1; }
mv "$TMP_FILE" "$SERVICE_LOC" || { echo "[ERROR] Failed to move tmp to $SERVICE_LOC"; exit 1; }
