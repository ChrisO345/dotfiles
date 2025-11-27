# Load Shell Config Files
[ -f "$XDG_CONFIG_HOME/shell/alias.sh" ] && source "$XDG_CONFIG_HOME/shell/alias.sh"
[ -f "$XDG_CONFIG_HOME/shell/funcs.sh" ] && source "$XDG_CONFIG_HOME/shell/funcs.sh"
[ -f "$XDG_CONFIG_HOME/shell/vars.sh" ] && source "$XDG_CONFIG_HOME/shell/vars.sh"

# Redirect zcompdump to $XDG_CACHE_HOME
export ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/zcompdump"
mkdir -p "$(dirname "$ZSH_COMPDUMP")"

# Enable Zsh Modules
zmodload zsh/complist
autoload -U compinit && compinit -d "$ZSH_COMPDUMP"
autoload -U colors && colors

# Load Dircolors
eval "$(dircolors -b $XDG_CONFIG_HOME/shell/.dircolors)"

# Completion Settings
# zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' squeeze-slashes false

# Shell Options
setopt append_history       # Append to history file, don’t overwrite
setopt inc_append_history   # Save each command as it's entered
setopt share_history        # Share history across all sessions
setopt auto_menu            # Show completions after partial input
setopt menu_complete        # Complete with menu behavior
setopt autocd               # Allow changing directories without 'cd'
setopt auto_param_slash     # Add trailing slash to directories
setopt no_case_glob         # Case-insensitive globbing
setopt no_case_match        # Case-insensitive matching
setopt globdots             # Include dotfiles in globbing
setopt extended_glob        # Enable extended globbing patterns
setopt interactive_comments # Allow comments in interactive shell
stty stop undef             # Disable Ctrl+S (XOFF)

# History Configuration
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$XDG_CACHE_HOME/zsh_history"
HISTCONTROL=ignoreboth      # Ignore duplicates and commands starting with space

# FZF Integration
source <(fzf --zsh)

# Key Bindings
bindkey -e  # Use Emacs key bindings to disable modal editing
bindkey '^[[Z' reverse-menu-complete

# History Navigation Bindings
bindkey "^[[B" history-search-forward
bindkey "^[[A" history-search-backward
bindkey "^R" fzf-history-widget

# Allow the use of extra ctrl keys
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# TMUX
bindkey -s '^f' "~/.config/tmux/scripts/session.sh\n"

# Prompt Configuration
NEWLINE=$'\n'

# OCaml
[[ ! -r '~/.opam/opam-init/init.zsh' ]] || source '~/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
eval "$(opam env)"

# Initialise Plugins
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
