#!/usr/bin/env bash

dry_run="0"

if [ -z "$CONFIG_HOME" ]; then
  echo "CONFIG_HOME is not set, using ~/.config"
  CONFIG_HOME="$HOME/.config"
fi

if [ -z "$DEV_ENV" ]; then
  echo "Environment Variable DEV_ENV needs to be present"
  exit 1
fi

if [[ $1 == "--dry" ]]; then
  dry_run="1"
  shift
fi

log() {
  local message="$1"
  local color="35"
  if [ "$dry_run" -eq "0" ]; then
    echo -e "\033[${color}m$message\033[0m"
  else
    echo -e "\033[33m[DRY RUN] \033[${color}m$message\033[0m"
  fi
}

log "Starting setup for $DEV_ENV"

update_files() {
  log "Copying files from $1"
  pushd $1 &>/dev/null
  (
    configs=$(find . -mindepth 1 -maxdepth 1 -type d)
    for c in $configs; do
      directory=${2%/}/${c#./}
      log "    Removing: rm -rf $directory"

      if [[ $dry_run == "0" ]]; then
        rm -rf $directory
      fi

      log "    Copying Directory: cp $c $2"
      if [[ $dry_run == "0" ]]; then
        cp -r ./$c $2
      fi
    done
  )
  popd &>/dev/null
}

copy() {
  log "    Removing: $2"
  if [[ $dry_run == "0" ]]; then
    rm $2
  fi
  log "    Copying: $1 to $2"
  if [[ $dry_run == "0" ]]; then
    cp $1 $2
  fi
}

log "Copying files from $DEV_ENV"
copy $DEV_ENV/.gitconfig $HOME/.gitconfig

log "Copying folders from $DEV_ENV/env"
update_files $DEV_ENV/env/.config $CONFIG_HOME
