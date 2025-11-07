#!/usr/bin/env bash

mapfile -t fonts < <(fc-list :spacing=100 -f "%{family[0]}\n" \
  | grep -v -i -E 'emoji|signwriting|omarchy' \
  | sort -u)

for font in "${fonts[@]}"; do
  echo "[[items]]"
  echo "label = \"$font\""
  echo "exec = \"$HOME/.config/dotmgr/scripts/font_change.sh '$font'\""
  echo ""
done
