#!/usr/bin/env bash

MIC_STATUS=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

[[ "$MIC_STATUS" == "yes" ]] && echo "false" || echo "true"

