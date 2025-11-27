#!/usr/bin/env bash

TS_SEARCH_PATHS=(
  ~/personal
  ~/dev
)

tree() {
  eza --tree --icons --group-directories-first "$@"
}

sanity_check() {
  command -v tmux >/dev/null 2>&1 || {
    echo "tmux is not installed."
    exit 1
  }
  command -v fzf >/dev/null 2>&1 || {
    echo "fzf is not installed."
    exit 1
  }
}

is_tmux_running() {
  pgrep tmux >/dev/null 2>&1
}

switch_to() {
  if [[ -z $TMUX ]]; then
    tmux attach-session -t "$1"
  else
    tmux switch-client -t "$1"
  fi
}

has_session() {
  tmux list-sessions 2>/dev/null | grep -q "^$1:"
}

find_dirs() {
  # Get existing session names
  existing_sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null || true)

  for dir in "${TS_SEARCH_PATHS[@]}"; do
    [[ -d "$dir" ]] || continue
    find "$dir" -mindepth 1 -maxdepth 1 -type d | while read -r d; do
      # basename to check against session names
      name=$(basename "$d" | tr . _)
      if ! echo "$existing_sessions" | grep -qx "$name"; then
        echo "$d"
      fi
    done
  done
}

sanity_check

selection=$({
  tmux list-sessions -F "[TMUX] #{session_name} #{session_path}" 2>/dev/null | while read -r line; do
    session_name=$(echo "$line" | awk '{print $1,$2}')
    session_dir=$(echo "$line" | cut -d' ' -f3-)
    echo "$session_dir|$session_name"
  done

  # Directories
  find_dirs | while read -r dir; do
    echo "$dir|$dir"
  done
} | fzf --delimiter='|' --with-nth=2 \
  --preview 'eza --tree --icons --color=always --group-directories-first -L 1 {1}' \
  --preview-window=right:40%)

[[ -z $selection ]] && exit 0

# Extract fields after selection
selected=$(echo "$selection" | cut -d'|' -f1)

# Remove [TMUX] prefix if it exists
[[ "$selected" =~ ^\[TMUX\]\ (.+)$ ]] && selected="${BASH_REMATCH[1]}"

selected_name=$(basename "$selected" | tr . _)

# Create session if it doesn't exist
if ! is_tmux_running || ! has_session "$selected_name"; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

switch_to "$selected_name"
