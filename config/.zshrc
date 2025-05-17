# Zsh Themes
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
# plugins=(
#     git
# )
#
# source $ZSH/oh-my-zsh.sh


# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Profile
source ~/.zsh_profile

# Bindkeys
# bindkey -e

# Config Installer Script (KeyStone)
alias keystone='bash "$DOTFILES/keystone/keystone"'

# Run Starship Prompt
eval "$(starship init zsh)"
