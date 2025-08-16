#!/usr/bin/env bash

terminal() {
  ghostty --class=dotfiles.floating -e "$1"
}

menu() {
  local prompt="$1"
  local options="$2"
  local extra="$3"
  local preselect="$4"

  read -r -a args <<<"$extra"

  if [[ -n "$preselect" ]]; then
    local index
    index=$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)
    if [[ -n "$index" ]]; then
      args+=("-a" "$index")
    fi
  fi

  echo -e "$options" | walker --dmenu --theme dmenu -p "$prompt…" "${args[@]}"
}

show_system_menu() {
  case $(menu "System" "  Lock\n󰤄  Suspend\n󰜉  Restart\n󰐥  Shutdown") in
  *Lock*) hyprlock ;;
  *Suspend*) systemctl suspend ;;
  *Restart*) systemctl reboot ;;
  *Shutdown*) systemctl poweroff ;;
  *) show_main_menu ;;
  esac
}

show_main_menu() {
  go_to_menu "$(menu "Go" "󰀻  Apps\n󰉉  Install\n󰭌  Remove\n  System")"
}

go_to_menu() {
  case "${1,,}" in
  *apps*) walker -p "Launch..." ;;
  *install*) terminal pkg_install.sh ;;
  *remove*) terminal pkg_remove.sh ;;
  *system*) show_system_menu ;;
  esac
}

if [[ -n "$1" ]]; then
  go_to_menu "$1"
else
  show_main_menu
fi
