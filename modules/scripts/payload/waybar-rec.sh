#!/usr/bin/env bash
#
# Copyright (C)  2025  BreadOnPenguins
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

# Hi, Bread. I'm technically breaching your license because I can't actually put
# the correct copyright notice. If you would like for me to adjust the copyright
# notice just reach me @ `yildirim.emir@metu.edu.tr` or `jayshozie@gmail.com` or
# <https://github.com/jayshozie>.
#
# I know it doesn't exactly look like yours, but technically this file started
# identical to yours. Thus, your copyright notice.

PID_FILE="/tmp/rec-state"
VIDEO_DIR="${HOME}/videos"

WF_OPTS="-c libx264rgb -x rgb24 -r 60 -p preset=ultrafast -p qp=0"

if [[ "$1" == "toggle" ]]; then
    mkdir -p "$VIDEO_DIR"

    if [[ -f "$PID_FILE" ]]; then
        read -r vid_pid aud_pid start_time < "$PID_FILE"

        kill -15 "$vid_pid" 2>/dev/null
        kill -15 "$aud_pid" 2>/dev/null

        # ordering matters
        makoctl mode -s default
        sleep 0.5
        notify-send --urgency=normal "Rec •" "Recording saved."

        rm -f "$PID_FILE"
    else
        timestamp=$(date '+%b-%d-%H%M%S')
        video_path="${VIDEO_DIR}/video_${timestamp}.mkv"
        audio_path="${VIDEO_DIR}/audio_${timestamp}.wav"

        # ordering matters
        notify-send --urgency=normal "Rec •" "Recording started."
        sleep 0.5
        makoctl mode -s dnd

        wf-recorder $WF_OPTS --file="$video_path" &
        vid_pid=$!

        ffmpeg -v quiet -f pulse -i default -ac 2 "$audio_path" &
        aud_pid=$!

        echo "$vid_pid $aud_pid $(date +%s)" > "$PID_FILE"
    fi
    exit 0
fi

while true; do
    if [[ -f "$PID_FILE" ]]; then
        read -r vid_pid aud_pid start_ts < "$PID_FILE"
        if kill -0 "$vid_pid" 2>/dev/null; then
            current_ts=$(date +%s)
            elapsed=$((current_ts - start_ts))

            # Format time MM:SS
            timer=$(date -d@"$elapsed" -u +%M:%S)

            text="Rec •"
            tooltip="Recording... (Elapsed: $timer)"
            class="recstart"
        else
            rm -f "$PID_FILE"
            continue
        fi
    else
        text="Rec"
        tooltip="Ready to record."
        class="recstop"
    fi

    printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' \
        "$text" "$class" "$tooltip"

    sleep 1
done
