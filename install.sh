#!/bin/bash

CONFIG_DIR="$HOME/.config"
NVIM_CONFIG="$(pwd)/nvim"

cleanup() {
  rm -rf "$CONFIG_DIR/nvim"
  rm -rf "$HOME/.local/share/nvim/lazy"
  rm -rf "$HOME/.local/state/nvim/lazy"
}

while getopts 'd' opt; do
  case "$opt" in
    d) cleanup
       exit 0 ;;
    *) # do nothing
  esac
done

if [[ -d "$CONFIG_DIR/nvim" ]]
then
	echo "Config already exists, clean before continuing: $CONFIG_DIR/nvim"
  echo "Usage: ./install.sh -d to clean to clean all dirs"
	exit 1
fi

cp -r "$NVIM_CONFIG" "$CONFIG_DIR"
