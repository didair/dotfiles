#!/bin/bash

# regreet setup
# Usage: ./regreet/setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symbolic links for Wofi configuration
echo "Setting up regreet configuration..."
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
  sudo ln -sf "$src" "$dest"
  echo "Linked $src to $dest"
}


# Link main config files
create_link "$SCRIPT_DIR/config.toml" "/etc/greetd/config.toml"
create_link "$SCRIPT_DIR/regreet.toml" "/etc/greetd/regreet.toml"
create_link "$SCRIPT_DIR/hyprland.conf" "/etc/greetd/hyprland.conf"

echo "Wofi setup completed successfully!"
