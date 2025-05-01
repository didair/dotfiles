#!/bin/bash

# Neovim setup script
# Usage: ./neovim/setup.sh [--update]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
UPDATE_MODE=false

# Process arguments
for arg in "$@"; do
  case $arg in
    --update)
      UPDATE_MODE=true
      shift
      ;;
  esac
done

# Create nvim config directory if it doesn't exist
mkdir -p "$NVIM_CONFIG_DIR"

# Create symbolic links for neovim configuration
echo "Setting up Neovim configuration..."
create_link() {
  local src="$1"
  local dest="$2"
  
  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$dest")"
  
  # Remove existing file/directory if it exists
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    local timestamp=$(date +%Y%m%d_%H%M%S)
    echo "Backing up existing $dest"
    mv "$dest" "$dest.backup_$timestamp"
  elif [ -L "$dest" ]; then
    rm "$dest"
  fi
  
  # Create the symbolic link
  ln -sf "$src" "$dest"
  echo "Linked $src to $dest"
}

# Link main config files
create_link "$SCRIPT_DIR/init.lua" "$NVIM_CONFIG_DIR/init.lua"

# Link any additional configuration files/directories
if [ -d "$SCRIPT_DIR/lua" ]; then
  create_link "$SCRIPT_DIR/lua" "$NVIM_CONFIG_DIR/lua"
fi

if [ -d "$SCRIPT_DIR/after" ]; then
  create_link "$SCRIPT_DIR/after" "$NVIM_CONFIG_DIR/after"
fi

# Install/update Packer (plugin manager)
PACKER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
  echo "Installing packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
else
  if [ "$UPDATE_MODE" = true ]; then
    echo "Updating packer.nvim..."
    git -C "$PACKER_DIR" pull
  fi
fi

# Install/update plugins
echo "Installing/updating Neovim plugins..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "Neovim setup completed successfully!"
