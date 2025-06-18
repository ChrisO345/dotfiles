# General Shortcuts
alias cls="clear"
alias v="nvim"
alias shell="exec \$SHELL -l"

# Neovim aliases
alias vf='nvim $(fd . -t f | fzf)'
alias vfm='nvim $(fd . -t f | fzf -m)'

# File & Directory Operations
alias mv="mv -i"
alias rm="rm -Iv"
alias df="df -h"
alias du="du -h -d 1"

# Variants
alias ls="eza --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias cd="z"

# Improved Tools
alias grep="grep --color=auto"
alias ctree="tree -a -I '.git|node_modules|bower_components|vendor' --dirsfirst | wl-copy"

# Git Shortcuts
alias gis="git status"
