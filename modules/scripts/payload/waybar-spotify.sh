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

export LYRICS_D='/tmp/lyrics.d'
export DEV_ENV='/home/jaysh/dev'
export SCRIPTS="${DEV_ENV}/modules/scripts/payload"

source "${DEV_ENV}/lib/urlencode" && \
        export -f urlencode
source "${SCRIPTS}/waybar-lyrics.sh" && \
    export -f get_lyrics
# source "${DEV_ENV}/lib/log" && \
#     export -f log && \
#     export DEBUG_RUN='1'

max_title_width=32

if ! command -v 'spotify-launcher' >& /dev/null; then
    exit 1
fi

while true; do
    coproc 'IS_SPOTIFY_RUNNING' {
        if ! pidof 'spotify' > /dev/null 2>&1; then
            echo ''
            sleep 3
        fi
    }

    player_status=$(\
        playerctl --player=spotify metadata --format \
        '{{status}};{{mpris:length}};{{position}};{{xesam:title}};{{xesam:artist}};{{xesam:album}}' \
    )

    if [[ -z "$player_status" ]]; then
        echo ""
        sleep 1
        continue
    fi

    IFS=';' read -r stat dur pos track artist album <<< "$player_status"

    if [[ -z "$dur" ]]; then
        dur=0
    else
        dur=$((dur / 1000000)) # from microseconds to seconds
    fi
    if [[ -z "$pos" ]]; then
        pos=0
    else
        pos=$((pos / 1000000)) # from microseconds to seconds
    fi
    if [[ "$dur" -eq 0 ]]; then
        dur=-1
        pos=0
    fi

    # str get_lyrics(str artist_name, str track, str album, int duration)
    # duration is in seconds
    # return is in /tmp/${artist_url}-${album_url}-${track_url}.lyrics"
    get_lyrics "$artist" "$track" "$album" "$dur"

    # about the pattern substitution:
    # LRCLIB made a change in their API, now spaces are not the standard `%20`
    # but `+` characters instead, so we have to manually change them.
    artist_url=$(urlencode "$artist")
    artist_url=${artist_url//%20/+}
    album_url=$(urlencode "$album")
    album_url=${album_url//%20/+}
    track_url=$(urlencode "$track")
    track_url=${track_url//%20/+}

    if [[ ! -d "$LYRICS_D" ]]; then
        mkdir -p "$LYRICS_D"
    fi

    lyrics_file="${LYRICS_D}/${artist_url}-${album_url}-${track_url}.lyrics"
    lyrics=$(cat "$lyrics_file")

    if [[ "$dur" -gt 0 ]] && [[ "$dur" -lt 3600 ]]; then
        time="[$(date -d@$pos -u +%M:%S) / $(date -d@$dur -u +%M:%S)]"
    else
        time='[--:--]'
    fi

    if [[ -n "$track" ]]; then
        if [[ "$stat" = 'Playing' ]]; then
            play_state=' '
            css_class='playing'
        elif [[ "$stat" = 'Paused' ]]; then
            play_state=' '
            css_class='paused'
        else
            play_state=''
            css_class='paused'
        fi
        output="$play_state $track - $artist"
    else
        output=''
    fi

    if [[ "${#output}" -ge $max_title_width ]]; then
        output="${output:0:$max_title_width}..."
    fi

    if [[ -n "$output" ]]; then
        text="$output $time"
    else
        text="$time"
    fi

    tooltip=''
    if [[ -n $track ]]; then
        tooltip="$track"
    fi
    if [[ -n $artist ]]; then
        tooltip+=" by $artist"
    fi
    if [[ -n $album ]]; then
        tooltip+=" in album $album"
    fi
    if [[ ! -z $lyrics ]]; then
############################## SINGLE EXPRESSION ##############################
        tooltip+="

Lyrics:
-------
$lyrics"
############################## SINGLE EXPRESSION ##############################
    fi

    jq -n -c \
        --arg txt "$text" \
        --arg ttip "$tooltip" \
        --arg cls "$css_class" \
        '{text: $txt, class: $cls, tooltip: $ttip}'

    sleep .1
done
