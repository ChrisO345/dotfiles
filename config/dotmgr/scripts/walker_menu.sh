#!/usr/bin/env bash

export PATH="$HOME/.config/dotmgr/scripts:$PATH"

THEMES_PATH="$HOME/.config/dotmgr/themes"

menu_back() {
  if [[ $NO_PARENT -eq 0 ]]; then
    show_main_menu
  else
    exit 0
  fi
}

terminal() {
  ghostty --class=dotmgr.floating.small -e "$1"
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

  echo -e "$options" | walker --dmenu --theme dmenu -p "$prompt..." "${args[@]}"
}

get_themes_menu() {
  local current_file="$THEMES_PATH/_current/current.txt"
  local current_theme
  local styled_curr
  local themes=()

  # Read the current theme
  if [[ ! -f "$current_file" ]]; then
      echo "Error: $current_file not found"
      return 1
  fi
  current_theme=$(<"$current_file")

  for dir in "$THEMES_PATH"/*/; do
      dir_name=$(basename "$dir")
      [[ "$dir_name" == "_current" ]] && continue
      theme_name="${dir_name}"
      theme_name=$(echo "$theme_name" | tr '_' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')
      if [[ "$dir_name" == "$current_theme" ]]; then
        styled_curr=$theme_name
      fi
      echo "THEME: $theme_name"
      themes+=("$theme_name")
  done

  local chosen=$(menu "Themes" "$(printf '%s\n' "${themes[@]}")" "" "$styled_curr")
  if [[ -z "$chosen" ]]; then
    menu_back
    return
  fi
  chosen=$(echo "$chosen" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
  theme_change.sh $chosen
}

show_style_menu() {
  case $(menu "Style" "󰖧  Themes\n󰖨  Fonts") in
  *Themes*) get_themes_menu ;;
  *Fonts*) notify-send "Fonts" "This feature is not implemented yet." ;;
  *) menu_back ;;
  esac
}

show_power_menu() {
  case $(menu "Power" "  Lock\n  Logout\n󰤄  Suspend\n󰜉  Restart\n󰐥  Shutdown") in
  *Lock*) hyprlock ;;
  *Logout*) hyprctl dispatch exit ;;
  *Suspend*) systemctl suspend ;;
  *Restart*) systemctl reboot ;;
  *Shutdown*) systemctl poweroff ;;
  *) menu_back ;;
  esac
}

show_main_menu() {
  go_to_menu "$(menu "Go" "󰀻  Apps\n  Style\n󰉉  Install\n󰭌  Remove\n  Power")"
}

go_to_menu() {
  case "${1,,}" in
  *apps*) walker -p "Launch..." ;;
  *style*) show_style_menu ;;
  *install*) terminal pkg_install.sh ;;
  *remove*) terminal pkg_remove.sh ;;
  *power*) show_power_menu ;;
  esac
}

NO_PARENT=0
if [[ -n "$1" ]]; then
  NO_PARENT=1
  go_to_menu "$1"
else
  show_main_menu
fi
