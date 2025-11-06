#!/usr/bin/env bash

export PATH="$HOME/.config/dotmgr/scripts:$PATH"

fzf_args=(
  --multi
  --preview 'echo "alt-p: toggle description, alt-j/k: scroll, super-f: maximize"; echo; paru -Qi {1}'
  --preview-window 'down:65%:wrap'
  --bind 'alt-p:toggle-preview'
  --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
  --bind 'alt-k:preview-up,alt-j:preview-down'
  --height '100%'
)

pkg_names=$(paru -Qqe | fzf "${fzf_args[@]}")

if [[ -n "$pkg_names" ]]; then
  # paru -Rns --noconfirm "${pkg_name[@]}"
  echo "$pkg_names" | tr '\n' ' ' | xargs paru -Rns --noconfirm
  # sudo updatedb
  dotfiles_done.sh
fi
