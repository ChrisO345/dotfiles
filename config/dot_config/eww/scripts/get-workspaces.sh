#!/usr/bin/env bash

# hyprctl workspaces -j | jq -c '
#   sort_by(.id) as $workspaces |
#   [range(1; 6) as $id |
#     ($workspaces[] | select(.id == $id)) // {id: $id, name: "Workspace \($id)", windows: 0}
#   ]
# '
hyprctl workspaces -j | jq -c 'sort_by(.id)'

socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
  hyprctl workspaces -j | jq -c 'sort_by(.id)'
done
