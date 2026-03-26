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

# Dude, thanks you so much. That is probably the most elegant way of solving
# this I've seen. I spent hours trying to come up with a pure-bash way, but I
# couldn't do it without xxd etc.
#
# Function `urlencode` is originally written by:
# Author: Dave Eddy <dave@daveeddy.com>
# Date: July 08, 2025
# License: MIT
# Usage: urlencode "string"
urlencode() {
    local LC_ALL=C
    for (( i = 0; i < ${#1}; i++ )); do
        : "${1:i:1}"
        case "$_" in
            [a-zA-Z0-9.~_-])
                printf '%s' "$_"
                ;;
            *)
                printf '%%%02X' "'$_"
                ;;
        esac
    done
}

# LRCLIB API Call Format:
# https://lrclib.net/api/get?artist_name=Artist+Name&track_name=Track+Name&album_name=Album+Name&duration=duration
# Duration is in seconds

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
    local uri="https://lrclib.net/api/get?artist_name=${artist_name}&track_name=${track_name}&album_name=${album_name}&duration=${duration}"
    local api_resp=$(curl -s ${uri})
    lyrics=$(echo "$api_resp" | jq -r '.plainLyrics // ""')
    # remove the `"` characters around the text
    # lyrics=${lyrics:1:${#lyrics}}
    # lyrics=${lyrics:0:-1}
    REPLY="$lyrics"
}

# DEV_ENV="/home/jaysh/dev"
# LIB="${DEV_ENV}/lib"
# source "${LIB}/log" && export -f log
# source "${LIB}/term-colors"
# get_lyrics 'PinkPantheress' 'Stateside + Zara Larsson' 'Fancy Some More?' '185'
# echo "$REPLY"
# echo $(get_lyrics $1 $2 $3 $4)
# REPLY=$(get_lyrics $1 $2 $3 $4)
