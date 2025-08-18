#!/usr/bin/env bash

export PATH="$HOME/.config/dotmgr/scripts:$PATH"

THEMES_PATH="$HOME/.config/dotmgr/themes"

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
    show_main_menu
    return
  fi
  chosen=$(echo "$chosen" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
  theme_change.sh $chosen
}

show_style_menu() {
  case $(menu "Style" "󰖧  Themes\n󰖨  Fonts") in
  *Themes*) get_themes_menu ;;
  *Fonts*) notify-send "Fonts" "This feature is not implemented yet." ;;
  *) show_main_menu ;;
  esac
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
  go_to_menu "$(menu "Go" "󰀻  Apps\n  Style\n󰉉  Install\n󰭌  Remove\n  System")"
}

go_to_menu() {
  case "${1,,}" in
  *apps*) walker -p "Launch..." ;;
  *style*) show_style_menu ;;
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
# get_themes_menu
