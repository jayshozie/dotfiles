[[ $- != *i* ]] && return

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

[[ -f "$HOME/.bash_env" ]] && source "$HOME/.bash_env"
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# tmux-sessionizer thanks to ThePrimeagen
bind '"\C-f":"tmux neww tmux-sessionizer\n"'
