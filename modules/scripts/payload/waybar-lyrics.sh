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

cleanup_http_header() {
    local header="$1"
    local unwanteds='server|date|content-type|content-length|connection|vary'
    local err_codes='400|404|402|429|500|502|503|504'
    grep -viE "$unwanteds" "$header" | \
        grep -iE "$err_codes" - | \
        sponge "$header"
    return
}

api_call() {
    local uri="$1"
    local api_resp_file="$2"
    local lyrics_file="$3"
    coproc 'API_PIPELINE' {
        curl -s "$uri" --dump-header "$api_resp_file" | \
            jq -r '.plainLyrics // ""' | \
            iconv -t ASCII//TRANSLIT | \
            sed 's/^[ \t]*//' | \
            sed '/./,$!d' | \
            cat -s - | \
            fold -s -c -w 34 - | \
            pr -t -T -c2 -w 71 -l 100 -S' | ' - > "$lyrics_file"
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
    local track_name=$(urlencode "$2")
    local album_name=$(urlencode "$3")
    local duration=$4 # this is already given in seconds

    local api_pid_file="${LYRICS_D}/.pid.id"
    local http_header="${LYRICS_D}/.http.header"
    local lyrics_file="${LYRICS_D}/${artist_name}-${album_name}-${track_name}.lyrics"
    local fetching_msg='Fetching lyrics...'
    local uri="https://lrclib.net/api/get?artist_name=${artist_name}&track_name=${track_name}&album_name=${album_name}&duration=${duration}"
    local api_pid=''

    if [[ -f "$api_pid_file" ]]; then
        api_pid=$(cat "$api_pid_file")
        if ps -p "$api_pid" > /dev/null 2>&1; then
            echo "$fetching_msg" > "$lyrics_file"
            return
        else
            rm -f "$api_pid_file"
            return
        fi
    elif [[ ! -f "$lyrics_file" ]]; then
        api_call "$uri" "$http_header" "$lyrics_file"
        echo "$REPLY" > "$api_pid_file"
    fi

    # @TODO: No idea how to get rid of the redundant-ish, first check.
    #        Needs refactor.
    if [[ ! -f "$api_pid_file" && -f "$http_header" ]]; then
        cleanup_http_header "$http_header"
        local did_err=$(cat "$http_header")
        if [[ -n "$did_err" ]]; then
             echo -e 'No lyrics found.\n' > "$lyrics_file"
        fi
        rm -f "$http_header"
    fi
}
