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

if [[ -f 'cbench.sh' ]]; then
    bash './cbench.sh'
    echo
    echo '[bench] Done.'
    echo
elif [[ -f 'bench.sh' ]]; then
    bash './bench.sh'
    echo
    echo '[bench] Done.'
    echo
elif [[ -f 'bench' ]]; then
    bash './bench'
    echo
    echo '[bench] Done.'
    echo
else
    echo
    echo "[bench] No auto compiler at $(pwd)"
    echo
fi
