#!/usr/bin/env bash

export PATH="$HOME/.config/dotmgr/scripts:$PATH"

THEME_DIR="$HOME/.config/dotmgr/themes"

nice_name=$(echo "${1}" | tr '_' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')

# Validate that the theme exists
if [[ ! -d "$THEME_DIR/$1" ]]; then
    notify-send "Theme Change Error" "Theme '${nice_name}' does not exist."
    exit 1
fi

notify-send "Theme Change" "Changing theme to ${nice_name}"

# Delete the _current/walls directory if it exists
# hyprpaper loads wallpapers into memory, so it is safe to delete this directory.
if [[ -d "$THEME_DIR/_current/walls" ]]; then
    rm -rf "$THEME_DIR/_current/walls"
fi

# Copy the selected theme to the "_current" directory with replacement
cp -rT "$THEME_DIR/$1" "$THEME_DIR/_current"

# Make the current.txt file with the theme name
echo "$1" > "$THEME_DIR/_current/current.txt"

background_files=("$THEME_DIR/_current/walls/"*)
next_wall="${background_files[0]}" # TODO: Update this so that the chosen wallpaper persists across theme changes

wallpaper_change.sh "$next_wall"

# Reload applications
hyprctl reload
pkill -SIGUSR2 ghostty
# eww --restart open bar # This is done in wallpaper_change.sh to avoid the background overlap
swaync-client -rs

