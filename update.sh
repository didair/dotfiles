#!/bin/bash

# Arch Linux Dotfiles Updater
# Usage: ./update.sh [--pull] [--desktop|--thinkpad]

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PULL_CHANGES=false
PC_TYPE=""

# Process arguments
for arg in "$@"; do
  case $arg in
    --pull)
      PULL_CHANGES=true
      shift
      ;;
    --desktop)
      PC_TYPE="desktop"
      shift
      ;;
    --thinkpad)
      PC_TYPE="thinkpad"
      shift
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: ./update.sh [--pull] [--desktop|--thinkpad]"
      exit 1
      ;;
  esac
done

# Pull latest changes from Git if requested
if [ "$PULL_CHANGES" = true ]; then
  echo "Pulling latest changes from repository..."
  git -C "$DOTFILES_DIR" pull
fi

# Update system packages
echo "Updating system packages..."
sudo pacman -Syu --noconfirm
yay -Syu --noconfirm

# Function to update application-specific configurations
update_app() {
  local app="$1"
  if [ -f "$DOTFILES_DIR/$app/setup.sh" ]; then
    echo "Updating $app configuration..."
    bash "$DOTFILES_DIR/$app/setup.sh" --update
  fi
}

# Update configurations for all apps
update_app "i3"
update_app "neovim"
update_app "zsh"
update_app "picom"
# Add more as needed

# Install any new packages from app lists
install_new_packages() {
  local file="$1"
  if [ -f "$file" ]; then
    echo "Checking for new packages from $file..."
    while read -r package; do
      # Skip comments and empty lines
      [[ "$package" =~ ^# ]] || [ -z "$package" ] && continue
      
      # Check if package is installed
      if ! pacman -Qi "$package" &> /dev/null && ! yay -Qi "$package" &> /dev/null; then
        echo "Installing new package: $package"
        yay -S --needed --noconfirm "$package"
      fi
    done < "$file"
  fi
}

# Check for new packages in all relevant package lists
install_new_packages "$DOTFILES_DIR/apps/base.txt"
install_new_packages "$DOTFILES_DIR/apps/desktop.txt"
install_new_packages "$DOTFILES_DIR/apps/dev.txt"

# Install PC-specific packages if specified
if [ -n "$PC_TYPE" ]; then
  install_new_packages "$DOTFILES_DIR/apps/custom-$PC_TYPE.txt"
fi

echo "Update completed successfully!"
