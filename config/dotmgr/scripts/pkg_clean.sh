#!/usr/bin/env bash

export PATH="$HOME/.config/dotmgr/scripts:$PATH"

paru -Rns "$(pacman -Qdtq)" --noconfirm || true
# sudo updatedb
dotfiles_done.sh
