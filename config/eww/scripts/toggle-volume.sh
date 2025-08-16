#!/usr/bin/env bash

VOL_STATUS=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [[ $VOL_STATUS == "no" ]]; then
  pactl set-sink-mute @DEFAULT_SINK@ 1
else
  pactl set-sink-mute @DEFAULT_SINK@ 0
fi
