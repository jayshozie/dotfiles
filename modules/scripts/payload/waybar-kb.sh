#!/usr/bin/env bash

main() {
    while true; do
        # get the laytout name, have to hard-code it to keyd-virtual-keyboard,
        # but you can change it easily
        text=$(hyprctl devices -j | jq '.keyboards[] | select(.name == "keyd-virtual-keyboard") | .active_keymap')
        # tooltip=$(hyprctl devices -j | jq '.keyboards[]')

        # get rid of the quotes around the layout name
        text=${text##\"}
        text=${text%%\"}

        css_class='custom-kb'

        printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' \
            "$text" "$css_class" "$tooltip"

        # the main problem with this script is the time it takes to execute.
        # since we're calling both hyprctl and jq, it takes 7 milliseconds on my
        # machine, which is pretty beefed. that's the price we have to pay for
        # safety i guess.
    done
}

main "$@"
