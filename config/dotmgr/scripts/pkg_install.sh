#!/usr/bin/env bash

fzf_args=(
  --multi
  --preview 'echo "alt-p: toggle description, alt-j/k: scroll, super-f: maximize"; echo; paru -Sii {1}'
  --preview-window 'down:65%:wrap'
  --bind 'alt-p:toggle-preview'
  --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
  --bind 'alt-k:preview-up,alt-j:preview-down'
  --height '100%'
)

pkg_name=$(paru -Slq | fzf "${fzf_args[@]}")

if [[ -n "$pkg_name" ]]; then
  paru -Sy --noconfirm "$pkg_name"
  sudo updatedb
  dotfiles_done.sh
fi
