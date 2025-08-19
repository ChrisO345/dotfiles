#!/usr/bin/env bash

THEME_DIR="$HOME/.config/dotmgr/themes"

nice_name=$(echo "${1}" | tr '_' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')

# Validate that the theme exists
if [[ ! -d "$THEME_DIR/$1" ]]; then
    notify-send "Theme Change Error" "Theme '${nice_name}' does not exist."
    exit 1
fi

notify-send "Theme Change" "Changing theme to ${nice_name}"

# Delete the "_current" directory if it exists
if [[ -d "$THEME_DIR/_current" ]]; then
    rm -rf "$THEME_DIR/_current"
fi

# Copy the selected theme to the "_current" directory
cp -r "$THEME_DIR/$1" "$THEME_DIR/_current"

# Make the current.txt file with the theme name
echo "$1" > "$THEME_DIR/_current/current.txt"

# TODO: Update this so that the chosen wallpaper persists across theme changes
background_files=("$THEME_DIR/_current/walls/"*)
next_wall="${background_files[0]}"

PAPER="$THEME_DIR/_current/paper.conf"

# Delete Existing paper.conf if it exists
if [[ -f "$PAPER" ]]; then
    rm "$PAPER"
fi

# Create a file in _current called paper.conf with 
echo "\$currentBG = $next_wall" > "$PAPER"
echo "preload = \$currentBG" >> "$PAPER"
echo "wallpaper = ,\$currentBG" >> "$PAPER"


# Reload applications
hyprctl reload
eww --restart open bar
hyprctl hyprpaper reload ,"$next_wall"
swaync-client -rs

