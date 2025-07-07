# Fuctions for easy opening with fzf and rg
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
    # FIXME: there is an issue with this alias fzf does not auto-search when using -q
    selection="$("${fzf_cmd[@]}" -1 -q "$1")"
  fi

  if [ -n "$selection" ]; then
    local query file
    query="$(head -n1 <<< "$selection")"
    file="$(tail -n +2 <<< "$selection")" 
    nvim +"/$query" "$file"
  fi
}

