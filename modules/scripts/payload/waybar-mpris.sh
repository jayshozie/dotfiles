#!/usr/bin/env bash

# playing:
#  [title] [position / mpris:length]
# paused:
#  [title] [position / mpris:length]

# 1 s = 1M us

while true; do
    if [[ ! $(pgrep -x "spotify") ]]; then
        echo ""
        sleep 2
        continue
    fi

    player_status=$(playerctl --player=spotify metadata --format "{{status}};{{mpris:length}};{{position}};{{title}};{{xesam:artist}}" | grep -m1 "Playing" || true)
    status="Playing"
    max_title_width=30

    if [[ -z "$player_status" ]]; then
        player_status=$(playerctl --player=spotify metadata --format "{{status}};{{mpris:length}};{{position}};{{title}};{{xesam:artist}}" | grep -m1 "Paused" || true)
        status="Paused"
    fi

    if [[ -z "$player_status" ]]; then
        echo ""
        sleep 1
        continue
    fi

    title=$(echo "$player_status" | cut -d';' -f4)
    artist=$(echo "$player_status" | cut -d';' -f5)
    length=$(echo "$player_status" | cut -d';' -f2)
    position=$(echo "$player_status" | cut -d';' -f3)

    if [[ -z "$length" ]]; then
        length=0
    fi
    if [[ -z "$position" ]]; then
        position=0
    fi

    length=$((length / 1000000))
    position=$((position / 1000000))

    if [[ "$length" -eq 0 ]]; then
        length=-1
        position=0
    fi

    if [[ "$length" -gt 0 ]] && [[ "$length" -lt 3600 ]]; then
        time="[$(date -d@$position -u +%M:%S) / $(date -d@$length -u +%M:%S)]"
    else
        time="[--:--]"
    fi

    if [[ -n "$title" ]]; then
        if [[ "$status" = "Playing" ]]; then
            play_state=" "
            css_class="playing"
        else
            play_state=" "
            css_class="paused"
        fi
        output="$play_state $title - $artist"
    else
        output=''
    fi

    if [[ "${#output}" -ge $max_title_width ]]; then
        output="${output:0:$max_title_width}..."
    fi

    if [[ -z "$output" ]]; then
        echo ""
    else
        text="$output $time"

        tooltip="$title by $artist"

        printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' \
            "$text" "$css_class" "$tooltip"
    fi

    sleep 1
done
