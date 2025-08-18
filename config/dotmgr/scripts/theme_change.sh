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

# Reload applications
eww --restart open bar

