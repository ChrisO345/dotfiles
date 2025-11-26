#!/usr/bin/env bash

THEME_DIR="$HOME/.config/dotmgr/themes"
PAPER="$THEME_DIR/_current/paper.conf"

wall_path="$1"

# Delete Existing paper.conf if it exists
if [[ -f "$PAPER" ]]; then
  rm "$PAPER"
fi

# Create a file in _current called paper.conf with
echo "\$currentBG = $wall_path" >"$PAPER"
echo "preload = \$currentBG" >>"$PAPER"
echo "wallpaper = ,\$currentBG" >>"$PAPER"

hyprctl hyprpaper reload ,"$wall_path"
eww --restart open bar # This is needed to have the eww bar be on top of the wallpaper
