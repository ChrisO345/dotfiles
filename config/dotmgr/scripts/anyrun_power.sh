#!/usr/bin/env bash

OPTIONS=(
  "Shutdown"
  "Restart"
  "Logout"
  "Lock"
)

ANYRUN_PLUGINS="$XDG_CONFIG_HOME/anyrun/lib/libstdin.so"

# Construct the menu options string
MENU_OPTIONS=""
for option in "${OPTIONS[@]}"; do
  MENU_OPTIONS+="$option\n"
done
MENU_OPTIONS="${MENU_OPTIONS%\\n}"

# Check if anyrun is installed
if ! command -v "$CARGO_HOME/bin/anyrun" &>/dev/null; then
  notify-send "anyrun not found" "Please install anyrun to use this script."
  exit 1
fi

selected_option=$(echo -e "$MENU_OPTIONS" | "$CARGO_HOME/bin/anyrun" --plugins "$ANYRUN_PLUGINS")

case "$selected_option" in
"Shutdown") shutdown now ;;
"Restart") shutdown -r now ;;
"Logout") hyprctl dispatch exit ;;
"Lock") hyprlock ;;
*) ;; # No valid selection or user cancelled
esac
