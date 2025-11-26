#!/usr/bin/env bash

export PATH="$HOME/.config/dotmgr/scripts:$PATH"

fzf_args=(
  --multi
  --preview 'echo "alt-i/I: toggle installed, alt-j/k: scroll, super-f: maximize"; echo; paru -Qi {1}'
  --preview-window 'down:65%:wrap'
  --bind "alt-d:preview-half-page-down,alt-u:preview-half-page-up"
  --bind "alt-k:preview-up,alt-j:preview-down"
  --bind "alt-i:reload(paru -Slq)"
  --bind "alt-I:reload(paru -Qqe)"
  --height '100%'
)

# Start with installed packages
paru -Qqe | fzf "${fzf_args[@]}"
