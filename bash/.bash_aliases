# .bash_aliases

# easier to type src then the whole command
alias src='source ~/.bashrc'

# netrw
alias nv='nvim .'

# i like it this way
alias ll='ls -lAh'

# better safe then sorry
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# automatically enable METU VPN because via-cli is trash
alias metuvpn='~/scripts/metuvpn.sh'

# my projects are small and mostly single filed so this script works fine
alias bench='~/scripts/which_bench.sh'

# sometimes it feels better to look at diffs, logs, and status in a text editor
alias utils='./utils.sh'

# you won't even believe how much i make changes to these files
alias dot='cd ~/dotfiles && nvim .'
alias lsp='cd ~/.config/nvim/ && nvim ./lua/jaysh/lazy/lsp.lua'
alias rc='nvim ~/.bashrc'
alias ali='nvim ~/.bash_aliases'
alias gitconf='nvim ~/.gitconfig'

# easier access to stuff i'm constantly working on
alias proj='cd ~/projects/'
alias scri='cd ~/scripts && nvim ~/scripts'

# waha-tui, to stay on the latest version
alias wp='waha-tui'
