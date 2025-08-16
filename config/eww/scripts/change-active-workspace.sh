#!/usr/bin/env bash

direction="$1"
current_ws="$2"


# Set workspace limits
min_ws=1
max_ws=10

case "$direction" in
  up)
    new_ws=$(( current_ws + 1 ))
    (( new_ws > max_ws )) && new_ws=$min_ws
    hyprctl dispatch workspace "$new_ws"
    ;;
  down)
    new_ws=$(( current_ws - 1 ))
    (( new_ws < min_ws )) && new_ws=$max_ws
    hyprctl dispatch workspace "$new_ws"
    ;;
  *)
    notify-send "Invalid direction: $direction. Use 'up' or 'down'."
    exit 1
    ;;
esac
