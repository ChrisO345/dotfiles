#!/usr/bin/env bash

LOCK_FILE="/tmp/eww-media.lock"
EWW_BIN="/usr/local/bin/eww"

if [ -f "$LOCK_FILE" ]; then
  $EWW_BIN close media
  rm -f "$LOCK_FILE"
else
  touch "$LOCK_FILE"
  $EWW_BIN open media
fi
