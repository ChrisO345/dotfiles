#!/usr/bin/env bash

THEMES_PATH="$HOME/.config/dotmgr/themes"

current_file="$THEMES_PATH/_current/current.txt"
paper_file="$THEMES_PATH/_current/paper.conf"

# Read the current theme
if [[ ! -f "$current_file" ]]; then
  echo "Error: $current_file not found"
  return 1
fi
current_theme=$(<"$current_file")

# Read the first line of paper.conf to get the current wallpaper
if [[ -f "$paper_file" ]]; then
  current_wallpaper=$(grep -m1 "^\$currentBG" "$paper_file" | cut -d'=' -f2 | tr -d ' ')
  current_wallpaper=$(basename "$current_wallpaper")
else
  current_wallpaper=""
fi

# Get all the wallpapers in the current theme
wallpapers=("$THEMES_PATH/${current_theme}/walls/"*)
for paper in "${wallpapers[@]}"; do
  paper_name=$(basename "$paper")

  echo "[[items]]"
  echo "label = \"$paper_name\""
  echo "exec = \"$HOME/.config/dotmgr/scripts/wallpaper_change.sh '$paper'\""
  echo ""
done
