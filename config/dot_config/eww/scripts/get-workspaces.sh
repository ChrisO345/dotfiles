#!/usr/bin/env bash

hyprctl workspaces -j | jq -c '
  sort_by(.id) as $ws |
  (
    [range(1;6) as $i |
      ($ws[] | select(.id == $i)) // {id: $i, name: "Workspace \($i)", windows: 0}
    ] + [
      $ws[] | select(.id >= 6)
    ]
  )
'

socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
hyprctl workspaces -j | jq -c '
  sort_by(.id) as $ws |
  (
    [range(1;6) as $i |
      ($ws[] | select(.id == $i)) // {id: $i, name: "Workspace \($i)", windows: 0}
    ] + [
      $ws[] | select(.id >= 6)
    ]
  )
'
done
