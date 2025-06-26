# General Shortcuts
alias cls="clear"
alias v="nvim"
alias shell="exec \$SHELL -l"

# Neovim aliases
nvf() {
  local file
  if [ -z "$1" ]; then
    file="$(fd . -t f | fzf)"
  else
    file="$(fd . -t f | fzf -1 -q $1)"
  fi

  if [ -n "$file" ]; then
    nvim "$file"
  fi
}

nrg() {
  local selection
  local fzf_cmd=(fzf --prompt="rg> " \
    --bind "change:reload:rg --files-with-matches --color=always {q} || true" \
    --ansi \
    --preview="rg --color=always --line-number {q} {}" \
    --phony --print-query)

  if [ -z "$1" ]; then
    selection="$("${fzf_cmd[@]}")"
  else
    selection="$("${fzf_cmd[@]}" -1 -q "$1")"
  fi

  if [ -n "$selection" ]; then
    local query file
    query="$(head -n1 <<< "$selection")"
    file="$(tail -n +2 <<< "$selection")" 
    nvim +"/$query" "$file"
  fi
}

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
