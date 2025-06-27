#!/usr/bin/env bash

MIC_STATUS=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

if [[ $MIC_STATUS == "no" ]]; then
  pactl set-source-mute @DEFAULT_SOURCE@ 1
else
  pactl set-source-mute @DEFAULT_SOURCE@ 0
fi
