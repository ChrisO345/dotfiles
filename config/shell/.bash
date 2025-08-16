# Load Shell Config Files
[ -f "$XDG_CONFIG_HOME/shell/alias.sh" ] && source "$XDG_CONFIG_HOME/shell/alias.sh"
[ -f "$XDG_CONFIG_HOME/shell/vars.sh" ] && source "$XDG_CONFIG_HOME/shell/vars.sh"

# Setup a basic prompt
PS1='\[\e[0;32m\]\u@\h:\[\e[0;34m\]\w\[\e[0;31m\]\[\e[0m\]\n\$ '
