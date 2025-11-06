#!/bin/sh

# Default Programs
export EDITOR="nvim"
export SHELL="bash"
export TERM="xterm-ghostty"
export TERMINAL="xterm-ghostty"
export BROWSER="google-chrome-stable"

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# User Paths and Dotfiles
export DOTFILES="$HOME/personal/dotfiles"
export SCRIPT_BIN="$HOME/.local/bin"
export HYPRSHOT_DIR="$HOME/pictures/screenshots"

# Other Paths
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"

# Load OPAM environment
eval "$(opam env)"

# If not running in a login shell, source the .bashrc file
[[ $- != *i* ]] && return

# Source the .bashrc file if it exists
[ -f "$XDG_CONFIG_HOME/shell/.bash" ] && source "$XDG_CONFIG_HOME/shell/.bash"
