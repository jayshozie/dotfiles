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

# @TODO: Fix the overflow problem.
#        This could possibly be achieved by switching to C, or finding a tool
#        that can do the same thing.

export DEV_ENV='/home/jaysh/dev'
source "${DEV_ENV}/lib/urlencode" && \
    export -f urlencode

api_call() {
    local uri="$1"
    local lyrics_file="$2"

    coproc 'API_PIPELINE' {
        local raw_resp="${lyrics_file}.raw"
        local tmp_file="${lyrics_file}.tmp"
        local http_code=$(curl -s -w "%{http_code}" -o "$raw_resp" "$uri")
        if [[ "$http_code" == "200" ]]; then
            jq -r '.plainLyrics // ""' "$raw_resp" | \
                iconv -t ASCII//TRANSLIT | \
                sed 's/^[ \t]*//' | \
                sed '/./,$!d' | \
                cat -s - | \
                fold -s -c -w 34 | \
                pr -t -T -c2 -w 71 -l 100 -S' | ' > "$tmp_file"
            mv -f "$tmp_file" "$lyrics_file"
        else
            echo -e "No lyrics found.\n${uri}" > "$lyrics_file"
        fi
        rm -f "$raw_resp"
    }
    REPLY="$API_PIPELINE_PID"
}

# str get_lyrics(str artist_name, str title, str album, int duration)
# duration is in seconds
# Example Values:
#   artist_name  = Avenged Sevenfold
#   title        = Bat Country
#   album        = City of Evil
#   duration (s) = 311
get_lyrics() {
    local artist_name=$(urlencode "$1")
    artist_name=${artist_name//%20/+}
    local track_name=$(urlencode "$2")
    track_name=${track_name//%20/+}
    local album_name=$(urlencode "$3")
    album_name=${album_name//%20/+}
    local duration=$4 # this is already given in seconds

    local api_pid_file="${LYRICS_D}/.${artist_name}-${track_name}.pid.id"
    local lyrics_file="${LYRICS_D}/${artist_name}-${album_name}-${track_name}.lyrics"
    local fetching_msg='Fetching lyrics...'
    local uri="https://lrclib.net/api/get?artist_name=${artist_name}&track_name=${track_name}&album_name=${album_name}&duration=${duration}"
    local api_pid=''

    if [[ -f "$api_pid_file" ]]; then
        api_pid=$(cat "$api_pid_file")
        if ps -p "$api_pid" > /dev/null 2>&1; then
            if [[ ! -s "$lyrics_file" ]]; then
                echo "$fetching_msg" > "$lyrics_file"
            fi
            return
        else
            rm -f "$api_pid_file"
            return
        fi
    elif [[ ! -f "$lyrics_file" ]]; then
        api_call "$uri" "$lyrics_file"
        echo "$REPLY" > "$api_pid_file"
    fi
}
