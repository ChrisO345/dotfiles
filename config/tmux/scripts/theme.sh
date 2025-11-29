#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/dotmgr/themes/_current/colors.sh"

# --------------------------------------------------
# Minimal Color Assignments
# --------------------------------------------------
BG="${THEME[background]}"
FG="${THEME[foreground]}"
ACC="${THEME[accent]}"
BORDER="${THEME[border]}"
ALT="${THEME[alt_background]}" # fallback secondary background
ALT="${ALT:-$BG}"              # ensure exists

# --------------------------------------------------
# General Status Bar
# --------------------------------------------------
tmux set -g status-style "bg=$BG,fg=$FG"
tmux set -g status-left-length 40
tmux set -g status-right-length 80

# --------------------------------------------------
# Pane Borders
# --------------------------------------------------
tmux set -g pane-border-style "fg=$BORDER"
tmux set -g pane-active-border-style "fg=$ACC"

# --------------------------------------------------
# Messages / Mode
# --------------------------------------------------
tmux set -g message-style "bg=$ACC,fg=$BG"
tmux set -g mode-style "bg=$ALT,fg=$ACC"

# --------------------------------------------------
# Status Left: Session Name
# --------------------------------------------------
tmux set -g status-left "#[bg=$ACC,fg=$BG,bold] #S #[default]"

# --------------------------------------------------
# Windows
# --------------------------------------------------

# Active
tmux set -g window-status-current-format \
  "#[bg=$ALT,fg=$ACC,bold] #I:#W #[default]"

# Inactive
tmux set -g window-status-format \
  "#[bg=$BG,fg=$FG] #I:#W #[default]"

tmux set -g window-status-separator " "

# --------------------------------------------------
# Status Right (clock only, minimal)
# --------------------------------------------------
# tmux set -g status-right "#[fg=$ACC]#(date '+%Y-%m-%d %H:%M')#[default]"
