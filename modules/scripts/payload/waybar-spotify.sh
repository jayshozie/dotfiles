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

# playing:
#  [title] [position / mpris:length]
# paused:
#  [title] [position / mpris:length]

# 1 s = 1M us

export DEV_ENV="/home/jaysh/dev"
export SCRIPTS="${DEV_ENV}/modules/scripts/payload"
source "${SCRIPTS}/waybar-lyrics.sh" && export -f get_lyrics
source "${DEV_ENV}/lib/log" && export -f log && export DEBUG_RUN='1'

while true; do
    if [[ ! $(pgrep -x "spotify") ]]; then
        echo ""
        sleep 2
        continue
    fi

    player_status=$(playerctl --player=spotify metadata --format "{{status}};{{mpris:length}};{{position}};{{xesam:title}};{{xesam:artist}};{{xesam:album}}")
    max_title_width=30

    if [[ -z "$player_status" ]]; then
        echo ""
        sleep 1
        continue
    fi

    status=$(echo "$player_status" | cut -d';' -f1)
    duration=$(echo "$player_status" | cut -d';' -f2)
    position=$(echo "$player_status" | cut -d';' -f3)
    title=$(echo "$player_status" | cut -d';' -f4)
    artist=$(echo "$player_status" | cut -d';' -f5)
    album=$(echo "$player_status" | cut -d';' -f6)

    # str get_lyrics(str artist_name, str title, str album, int duration)
    # duration is in seconds
    # Example values and what they'll be converted into:
    #   artist_name  = Avenged Sevenfold = Avenged+Sevenfold
    #   title        = Bat Country       = Bat+Country
    #   album        = City of Evil      = City+of+Evil
    #   duration (s) = 311               = 311
    duration=$((duration / 1000000))
    position=$((position / 1000000))
    lyrics_file="/tmp/${title}"
    if [[ -f "$lyrics_file" ]]; then
        lyrics=$(cat "$lyrics_file")
    else
        get_lyrics "$artist" "$title" "$album" "$duration"
        lyrics=${REPLY}
        echo -E "$lyrics" > "$lyrics_file"
    fi

    if [[ -z "$duration" ]]; then
        duration=0
    fi
    if [[ -z "$position" ]]; then
        position=0
    fi

    if [[ "$duration" -eq 0 ]]; then
        duration=-1
        position=0
    fi

    if [[ "$duration" -gt 0 ]] && [[ "$duration" -lt 3600 ]]; then
        time="[$(date -d@$position -u +%M:%S) / $(date -d@$duration -u +%M:%S)]"
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
    fi

    if [[ ! -z $title ]]; then
        tooltip="$title"
    fi
    if [[ ! -z $artist ]]; then
        tooltip+=" by $artist"
    fi
    if [[ ! -z $lyrics ]]; then
        tooltip+="

$lyrics"
    fi

    jq -n -c \
        --arg txt "$text" \
        --arg ttip "$tooltip" \
        --arg cls "$css_class" \
        '{text: $txt, class: $cls, tooltip: $ttip}'

    sleep 1
done
