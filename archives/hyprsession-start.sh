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

clean_session_file() {
    local jq_arg='del(.[] | select(.class == "Alacritty"))'
    local session_file="${HOME}/.local/share/hyprsession/default/clients.json"
    if [[ -f "$session_file" ]]; then
        local file_content=$(cat "$session_file")
        while true; do
            if [[ -n "$file_content" ]]; then
                echo -nE "$file_content" | jq "$jq_arg" > "$session_file"
                break
            fi
        done
    fi
}

main() {
    # start hyprsession
    hyprsession & disown

    # immediately kill the tmux server
    while ! pgrep tmux-server; do
        # tmux kill-server
        echo 'running'
    done

    # clean the session file after waiting
    sleep 5 && clean_session_file

    # then run alacritty
    alacritty -e tmux
}

main "$@"
