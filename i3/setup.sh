#!/bin/bash

# i3 setup script
# Usage: ./i3/setup.sh [--update]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
I3_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/i3"
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

# Create i3 config directory if it doesn't exist
mkdir -p "$I3_CONFIG_DIR"

# Create symbolic links for i3 configuration
echo "Setting up i3 configuration..."
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

echo "Configure lock screen"
betterlockscreen -u ${XDG_DATA_HOME:-$HOME/.local/share}/wallpapers/waves-light.jpg

# Link i3 configuration file
create_link "$SCRIPT_DIR/config" "$I3_CONFIG_DIR/config"

# Link i3blocks configuration if it exists
if [ -f "$SCRIPT_DIR/i3blocks.conf" ]; then
  create_link "$SCRIPT_DIR/i3blocks.conf" "${XDG_CONFIG_HOME:-$HOME/.config}/i3blocks/config"
fi

# Set up additional i3 related configurations
# For example, picom (compositor) if needed
if [ -f "$SCRIPT_DIR/picom.conf" ]; then
  create_link "$SCRIPT_DIR/picom.conf" "${XDG_CONFIG_HOME:-$HOME/.config}/picom/picom.conf"
fi

# Set up wallpaper directory if needed
if [ -d "$SCRIPT_DIR/wallpapers" ]; then
  mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/wallpapers"
  cp -r "$SCRIPT_DIR/wallpapers/"* "${XDG_DATA_HOME:-$HOME/.local/share}/wallpapers/"
fi

sudo systemctl enable lightdm.service
sudo systemctl start lightdm.service

echo "i3 setup completed successfully!"
