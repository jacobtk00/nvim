#!/bin/bash

CONFIG_DIR="$HOME/.config"
NVIM_CONFIG="$(pwd)/nvim"

cleanup() {
  rm -rf "$CONFIG_DIR/nvim" 
  rm -rf "$HOME/.local/share/nvim/lazy"
  rm -rf "$HOME/.local/state/nvim/lazy"
  rm -rf "$HOME/.local/share/nvim"
}

while getopts 'd' opt; do
  case "$opt" in
    d) echo "removing nvim and all deps" && cleanup ; exit 1 ;;
    *) # do nothing
  esac
done


if [[ -d "$CONFIG_DIR/nvim" ]]
then
	echo "Config already exists, clean before continuing: $CONFIG_DIR/nvim"
  	echo "Usage: ./install.sh -d to clean to clean all dirs"
	exit 1
fi

if [[ $(find nvim -name "lazy.lua") ]]
then
	echo "Installing NVIM with LAZY package manager"
	ln -s "$NVIM_CONFIG" "$CONFIG_DIR"
  nvim --headless +Lazy Sync +qa
	exit 0
fi
