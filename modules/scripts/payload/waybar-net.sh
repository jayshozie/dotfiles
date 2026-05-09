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

# nmcli dev wifi list | awk '/\*/{if (NR!=1) {print $9}}'
# ^ wifi strength in bars
#
# {if wifi connected: 󰖩 wifi_strength} {if ethernet connected: 󰈀 <something>}

# interface names for when thunderbolt ethernet connection is available
tb_back='enp128s20f0u1'
tb_front='enp128s20f0u3'
rj45_back='enp129s0'
css_class='net'
secret='FiberHGW_TP8998'

while true; do
    wifi_text=''
    ethernet_text=''
    tooltip=''

    ###########
    #  Wi-fi  #
    ###########
    # DEBUG:
    # echo "LANG is: $LANG" >> ${HOME}/waybar-net-debug.log
    nmcli_output=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi list | grep '^yes')

    if [[ -n "$nmcli_output" ]]; then
        # Format from nmcli -t is: yes:SSID:▂▄▆_
        wifi_ssid=$(echo "$nmcli_output" | cut -d':' -f2)
        wifi_signal=$(echo "$nmcli_output" | cut -d':' -f3)

        if [[ "$wifi_signal" -gt 80 ]]; then
            wifi_bars='▂▄▆█'
        elif [[ "$wifi_signal" -gt 60 ]]; then
            wifi_bars='▂▄▆_'
        elif [[ "$wifi_signal" -gt 40 ]]; then
            wifi_bars='▂▄__'
        elif [[ "$wifi_signal" -gt 20 ]]; then
            wifi_bars='▂___'
        else
            wifi_bars='____'
        fi

        # DEBUG:
        # echo $nmcli_output > ${HOME}/waybar-net-debug.log

        if [[ $wifi_ssid == "$secret" ]]; then
            wifi_text="󰖩  $wifi_bars"
        elif [[ $wifi_ssid == '' ]]; then
            wifi_text=''
        else
            wifi_text="󰖩  $wifi_ssid  $wifi_bars"
        fi
        if [[ $wifi_ssid == '' ]]; then
            tooltip=''
        else
            tooltip="Wi-Fi: $wifi_ssid"
        fi
    else
        wifi_text=''
        tooltip=''
    fi

    ##############
    #  Ethernet  #
    ##############
    for iface in $(ls /sys/class/net); do
        # --- Filters ---
        [[ $iface == "lo" ]] && continue
        [[ -d "/sys/class/net/${iface}/wireless" ]] && continue
        [[ ! -L "/sys/class/net/${iface}/device" ]] && continue

        # check operstate
        state=$(cat "/sys/class/net/${iface}/operstate" 2>/dev/null)
        [[ $state == "down" ]] && continue

        # --- Mapping ---
        case "$iface" in
            "$tb_back")
                ethernet_text='  Rear'
                tooltip="${tooltip} | Ethernet: Thunderbolt Rear"
                ;;
            "$tb_front")
                ethernet_text='  Front'
                tooltip="${tooltip} | Ethernet: Thunderbolt Front"
                ;;
            "$rj45_back")
                ethernet_text='󰈀  RJ45'
                tooltip="${tooltip} | Ethernet: RJ45 Back"
                ;;
            *)
                ethernet_text='󰈀  Ext'
                tooltip="${tooltip} | Ethernet: External ($iface)"
                ;;
        esac
        break
    done

    if [[ $wifi_text == '' ]]; then
        text="${ethernet_text}"
    elif [[ $ethernet_text == '' ]]; then
        text="${wifi_text}"
    else
        text="${wifi_text}  |  ${ethernet_text}"
    fi

    # clean up tooltip
    tooltip="${tooltip# | }"

    printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' \
        "$text" "$css_class" "$tooltip"

    sleep 1
done
