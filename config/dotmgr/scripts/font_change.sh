#!/usr/bin/env bash

font_name="$1"

if [[ -n "$font_name" && "$font_name" != "CNCLD" ]]; then
  if fc-list | grep -iq "$font_name"; then
    if [[ -f ~/.config/dotmgr/fonts/ghostty ]]; then
      sed -i "s/font-family = \".*\"/font-family = \"$font_name\"/g" ~/.config/dotmgr/fonts/ghostty
      pkill -SIGUSR2 ghostty
    fi

    if [[ -f ~/.config/dotmgr/fonts/font.css ]]; then
      sed -i "s/font-family: .*/font-family: '$font_name';/g" ~/.config/dotmgr/fonts/font.css
      swaync-client -rs
    fi

    notify-send "Font Changed" "Font set to '$font_name'"
  else
    echo "Font '$font_name' not found."
    exit 1
  fi
else
  echo "Usage: font_change.sh <font-name>"
fi
