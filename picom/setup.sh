#!/bin/bash

# Picom setup script
# Usage: ./picom/setup.sh [--update]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR:-$HOME/.config")"
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

# Create symbolic links for Picom configuration
echo "Setting up Picom configuration..."
create_link() {
  local src="$1"
  local dest="$2"

  echo "Create symlink to $dest from $src"
  
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
create_link "$SCRIPT_DIR/picom.conf" "$XDG_CONFIG_HOME/picom.conf"

echo "Picom setup completed successfully!"
