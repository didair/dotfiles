#!/bin/bash

# regreet setup
# Usage: ./regreet/setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create copies for greetd configuration
echo "Setting up regreet configuration..."
create_copy() {
  local src="$1"
  local dest="$2"

  echo "Create copy from $src to $dest"

  # Create parent directory if it doesn't exist
  sudo mkdir -p "$(dirname "$dest")"
  
  # Create the symbolic link
  sudo cp "$src" "$dest"
  echo "Copied $src to $dest"
}


# Link main config files
create_copy "$SCRIPT_DIR/config.toml" "/etc/greetd/config.toml"
create_copy "$SCRIPT_DIR/regreet.toml" "/etc/greetd/regreet.toml"
create_copy "$SCRIPT_DIR/hyprland.conf" "/etc/greetd/hyprland.conf"

echo "greetd & regreet setup completed successfully!"
