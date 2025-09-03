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

show_wallpaper_menu() {
  local current_file="$THEMES_PATH/_current/current.txt"
  local paper_file="$THEMES_PATH/_current/paper.conf"
  local current_theme
  local themes=()

  # Read the current theme
  if [[ ! -f "$current_file" ]]; then
      echo "Error: $current_file not found"
      return 1
  fi
  current_theme=$(<"$current_file")

  # Read the first line of paper.conf to get the current wallpaper
  if [[ -f "$paper_file" ]]; then
    current_wallpaper=$(grep -m1 '^\$currentBG' "$paper_file" | cut -d'=' -f2 | tr -d ' ')
    current_wallpaper=$(basename "$current_wallpaper")
  else
    current_wallpaper=""
  fi

  # Get all the wallpapers in the current theme
  local wallpapers=("$THEMES_PATH/${current_theme}/walls/"*)
  
  # Join the wallpaper names into a single\n string
  for wall in "${wallpapers[@]}"; do
    wall_name=$(basename "$wall")
    if [[ -f "$wall" ]]; then
      themes+=("$wall_name")
    fi
  done
  local joined_themes=$(printf '%s\n' "${themes[@]}")
  local chosen=$(menu "Wallpapers" "$joined_themes" "" "$current_wallpaper")
  if [[ -z "$chosen" ]]; then
    menu_back
    return
  fi
  notify-send "Wallpaper Change" "Changing wallpaper to $chosen"
  change_background.sh "$THEMES_PATH/${current_theme}/walls/$chosen"
}

show_style_menu() {
  case $(menu "Style" "󰖧  Themes\n󰸉  Wallpapers\n󰖨  Fonts") in
  *Themes*) get_themes_menu ;;
  *Wallpapers*) show_wallpaper_menu ;;
  *Fonts*) notify-send "Fonts" "This feature is not implemented yet." ;;
  *) menu_back ;;
  esac
}

show_package_menu() {
  case $(menu "Packages" "󰉉  Install\n󰆜  Remove\n󰍛  Query\n  Update") in
    *Install*) terminal pkg_install.sh ;;
    *Remove*) terminal pkg_remove.sh ;;
    *Query*) terminal pkg_query.sh ;;
    *Update*) terminal pkg_update.sh ;;
    *) menu_back ;;
  esac
}

show_settings_menu() {
  notify-send "Settings" "This feature is not implemented yet."
}

show_meta_menu() { # Only accessible by running walker_menu.sh Meta
  case "$(menu "Meta" "󰓹  Hero")" in
  *Hero*) terminal dotfiles_done.sh ;;
  *) menu_back ;;
  esac
}

show_power_menu() {
  case $(menu "Power" "  Lock\n  Logout\n󰤄  Suspend\n󰝳  Restart\n󰐥  Shutdown") in
  *Lock*) hyprlock ;;
  *Logout*) hyprctl dispatch exit ;;
  *Suspend*) systemctl suspend ;;
  *Restart*) systemctl reboot ;;
  *Shutdown*) systemctl poweroff ;;
  *) menu_back ;;
  esac
}

show_main_menu() {
  go_to_menu "$(menu "Go" "󰀻  Apps\n  Style\n󰏖  Packages\n  Settings\n  Power")"
}

go_to_menu() {
  case "${1,,}" in
  *apps*) walker -p "Launch..." ;;
  *style*) show_style_menu ;;
  *packages*) show_package_menu ;;
  *settings*) show_settings_menu ;;
  *power*) show_power_menu ;;
  *meta*) show_meta_menu ;;
  esac
}

NO_PARENT=0
if [[ -n "$1" ]]; then
  NO_PARENT=1
  go_to_menu "$1"
else
  show_main_menu
fi
