#!/bin/bash

# Polybar setup script
# Usage: ./polybar/setup.sh [--update]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR:-$HOME/.config/polybar")"
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

# Create symbolic links for polybar configuration
echo "Setting up polybar configuration..."
create_link() {
  local src="$1"
  local dest="$2"

  echo "Create symlink to $dest from $src"

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
create_link "$SCRIPT_DIR/config.ini" "$XDG_CONFIG_HOME/polybar/config.ini"

chmod +x $SCRIPT_DIR/launch.sh

echo "Polybar setup completed successfully!"
