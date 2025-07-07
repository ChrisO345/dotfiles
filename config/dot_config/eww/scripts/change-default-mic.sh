#!/usr/bin/env bash

anyrun_plugins="$XDG_CONFIG_HOME/anyrun/lib/libstdin.so"
lookup_file="$XDG_CONFIG_HOME/eww/resources/mic.conf"

connected_devices=$(pactl list short sources | awk '{print $2}')

declare -A id_to_name
declare -A name_to_id

while IFS='=' read -r name id; do
    [[ -n "$name" && -n "$id" ]] && id_to_name["$id"]="$name" && name_to_id["$name"]="$id"
done < <(grep -v '^#' "$lookup_file")

choices=""
for id in $connected_devices; do
    name="${id_to_name[$id]}"
    if [[ -n "$name" ]]; then
        display="$name | $id"
        choices+="$name\n"
    else
        display="$id | $id"
        choices+="$id\n"
    fi
done

selected=$(echo -e "$choices" | /home/chris/.local/share/cargo/bin/anyrun --plugins "$anyrun_plugins")

if [[ -n "$selected" ]]; then
    selected_id="${name_to_id[$selected]}"
    if [[ -n "$selected_id" ]]; then
        pactl set-default-source "$selected_id"
        notify-send "Default microphone set to: $selected"
    else
        pactl set-default-source "$selected"
        notify-send "Default microphone set to: $selected (not found in lookup file)"
    fi
else
    notify-send "No microphone selected."
fi
