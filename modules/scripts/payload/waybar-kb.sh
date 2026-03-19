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

main() {
    while true; do
        # get the laytout name, have to hard-code it to keyd-virtual-keyboard,
        # but you can change it easily
        text=$(hyprctl devices -j | jq '.keyboards[] | select(.name == "keyd-virtual-keyboard") | .active_keymap')
        # tooltip=$(hyprctl devices -j | jq '.keyboards[]')

        # get rid of the quotes around the layout name
        text=${text##\"}
        text=${text%%\"}
        [[ $text == "English (Dvorak)" ]] && text="Dvorak"

        css_class='custom-kb'
        tooltip=''

        printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' \
            "$text" "$css_class" "$tooltip"
    done
}

main "$@"
