#!/usr/bin/env bash

LOCK_FILE="/tmp/eww-calendar.lock"
EWW_BIN="/usr/local/bin/eww"

if [ -f "$LOCK_FILE" ]; then
  $EWW_BIN close calendar
  rm -f "$LOCK_FILE"
else
  touch "$LOCK_FILE"
  $EWW_BIN open calendar
fi
