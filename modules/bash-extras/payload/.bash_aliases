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

# easier to type src then the whole command
alias src='source ~/.bashrc && hash -r'

# netrw
alias nv='nvim .'

# programs
alias img='imv'
alias vid='mpv'
alias yay='paru'
alias qalc='qalc --color --interactive'
alias calc='qalc --exrates --color --interactive'
alias gem='gemini'
alias crosscc='x86_64-elf-gcc'
alias crossld='x86_64-elf-ld'
alias master-sync='git fetch; sleep 1; git reset --hard origin/master'
alias project-tracker='systemctl enable postgresql.service || systemctl start postgresql.service && pgcli project_tracker'
alias bat-update='bat cache --build'
alias test-gpg='gpg-connect-agent reloadagent /bye && echo "test" | gpg --clearsign > /dev/null'
alias restart-waybar='pkill waybar; /home/jaysh/src/upstream/waybar/build/waybar 2>/dev/null 1>/dev/null & disown'

# i like it this way
alias ll='eza -liah --git'
alias sd='eza -liah --git --total-size' # size + dir = sd
alias grep='grep --color=auto -C 2'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias fd='fd -uic always'
alias find='fd -ui'
alias clear='clear -x'

# better safe then sorry
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# stupid stuff
alias chomd='chmod'
alias celar='clear'
alias claer='clear'
alias clera='clear'

# easier readability
alias df='df -h'
alias tree='tree -aC -I ".git"'

# sometimes it feels better to look at diffs, logs, and status in a text editor
alias utils='./utils.sh'
alias acp="git add . && git commit -m 'wip: automated dev-commit' && git push"

# you wouldn't even believe how much i make changes to these files
alias dev='cd ~/dev && nv'
alias lsp='pushd ~/dev/modules/neovim/payload && nvim ./lua/jaysh/lazy/lsp.lua && popd'
alias bashrc='nvim ~/dev/modules/bash/payload/.bashrc'
alias aliases='nvim ~/dev/modules/bash/payload/.bash_aliases'
alias gitconfig='nvim ~/dev/modules/git/payload/.gitconfig'

# easier access to stuff i'm constantly working on
alias jayshell='pushd ~/projects/c-mastery-projects/jayshell && nv'
alias scripts='pushd ~/dev/modules/scripts && nv && popd'
# alias docs='pushd ~/Documents' # became irrelevant when i switched to arch
alias downs='pushd ~/Downloads'
alias uni='pushd ~/uni'
alias 111='pushd ~/uni/ceng111'
alias 240='pushd ~/uni/ceng240'
alias 301='pushd ~/uni/ceng301'
alias 302='pushd ~/uni/ceng302'

# i usually sleep while my workstation is on, so i have an alias to shut it down
# automatically after 90 minutes
alias eepy='shutdown +90; (sleep 30m && hyprlock) & disown'
# here if i change my mind
alias uneepy='shutdown -c; pkill sleep'
