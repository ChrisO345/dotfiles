#!/usr/bin/env bash

OPTIONS=(
    "Shutdown"
    "Restart"
    "Logout"
)

POWER_CONFIG_DIR="$XDG_CONFIG_HOME/wofi/power_menu"

# Determine the number of lines to display in the menu (+1 for the prompt)
NUM_OPTIONS=$((${#OPTIONS[@]} + 1))

# Check if wofi is installed
if ! command -v wofi &> /dev/null; then
    echo "wofi could not be found. Please install wofi to use this script."
    exit 1
fi

failed="0"

# Check if wofi config and style files exist
if [ ! -f "$POWER_CONFIG_DIR/config" ]; then
    echo "Configuration file not found: $POWER_CONFIG_DIR/config"
    failed="1"
fi

if [ ! -f "$POWER_CONFIG_DIR/style.css" ]; then
    echo "Style file not found: $POWER_CONFIG_DIR/style.css"
    failed="1"
fi

if [ "$failed" -eq "0" ]; then
    # Construct the options for wofi
    WOFI_OPTIONS=""
    for option in "${OPTIONS[@]}"; do
	WOFI_OPTIONS+="$option\n"
    done
    WOFI_OPTIONS="${WOFI_OPTIONS%\\n}"  # Remove the trailing newline

    # Display the menu using wofi
    selected_option=$(echo -e "${WOFI_OPTIONS}" | wofi --dmenu --prompt "Power Menu" --lines $NUM_OPTIONS --conf $POWER_CONFIG_DIR/config --style $POWER_CONFIG_DIR/style.css --width 10%)

    # Perfom the action based on the selected option
    case "$selected_option" in
	"Shutdown") echo "Shutting down..."; shutdown now;;
	"Restart") echo "Restarting..."; shutdown -r now;;
	"Logout") echo "Logging out..."; hyprctl dispatch exit;;
	*) ;;
    esac
fi
