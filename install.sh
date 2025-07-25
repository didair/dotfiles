#!/bin/bash

# Arch Linux Dotfiles Installer
# Usage: ./install.sh [--minimal|--full] [--desktop|--thinkpad]

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
INSTALL_TYPE="full"
PC_TYPE=""

# Process arguments
for arg in "$@"; do
  case $arg in
    --minimal)
      INSTALL_TYPE="minimal"
      shift
      ;;
    --full)
      INSTALL_TYPE="full"
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
      echo "Usage: ./install.sh [--minimal|--full] [--desktop|--thinkpad]"
      exit 1
      ;;
  esac
done

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo "Please do not run as root"
  exit 1
fi

# Create backup of existing configs
echo "Creating backup of existing configurations..."
timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="$HOME/dotfiles_backup_$timestamp"
mkdir -p "$backup_dir"

# Backup existing configuration files
if [ -d "$CONFIG_HOME/nvim" ]; then
  cp -r "$CONFIG_HOME/nvim" "$backup_dir/"
fi

if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$backup_dir/"
fi

if [ -d "$CONFIG_HOME/picom" ]; then
  cp -r "$CONFIG_HOME/picom" "$backup_dir/"
fi

# ... similar for other config files

echo "Backup created at $backup_dir"

# Ensure system is up to date
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install package manager helper (paru) if not installed
if ! command -v paru &> /dev/null; then
  echo "Installing paru AUR helper..."
  sudo pacman -S --needed git base-devel --noconfirm
  git clone https://aur.archlinux.org/paru.git /tmp/paru
  (cd /tmp/paru && makepkg -si --noconfirm)
  rm -rf /tmp/paru
fi

# Install packages from app lists
install_packages() {
  local file="$1"
  if [ -f "$file" ]; then
    echo "Installing packages from $file..."
    while read -r package; do
      # Skip comments and empty lines
      [[ "$package" =~ ^# ]] || [ -z "$package" ] && continue
      echo "Installing: $package"
      paru -S --needed --noconfirm "$package"
    done < "$file"
  fi
}

# Install base packages for all configurations
install_packages "$DOTFILES_DIR/apps/base.txt"

# Install packages based on installation type
if [ "$INSTALL_TYPE" = "full" ]; then
  install_packages "$DOTFILES_DIR/apps/desktop.txt"
  install_packages "$DOTFILES_DIR/apps/dev.txt"
fi

# Install PC-specific packages if specified
if [ -n "$PC_TYPE" ]; then
  install_packages "$DOTFILES_DIR/apps/custom-$PC_TYPE.txt"
fi

# Create symbolic links for configuration files
create_link() {
  local src="$1"
  local dest="$2"
  
  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$dest")"
  
  # Remove existing file/directory if it exists
  if [ -e "$dest" ]; then
    if [ -L "$dest" ]; then
      rm "$dest"
    else
      echo "Backing up existing $dest"
      mv "$dest" "$dest.backup_$timestamp"
    fi
  fi
  
  # Create the symbolic link
  ln -sf "$src" "$dest"
  echo "Linked $src to $dest"
}

# Run application-specific setup scripts
echo "Setting up applications..."

# Setup Neovim
if [ -f "$DOTFILES_DIR/neovim/setup.sh" ]; then
  bash "$DOTFILES_DIR/neovim/setup.sh"
fi

# Setup Zsh
if [ -f "$DOTFILES_DIR/zsh/setup.sh" ]; then
  bash "$DOTFILES_DIR/zsh/setup.sh"
fi

# Setup hyprland
if [ "$INSTALL_TYPE" = "full" ] && [ -f "$DOTFILES_DIR/hypr/setup.sh" ]; then
  bash "$DOTFILES_DIR/hypr/setup.sh"
fi

# Setup Waybar
if [ "$INSTALL_TYPE" = "full" ] && [ -f "$DOTFILES_DIR/waybar/setup.sh" ]; then
  bash "$DOTFILES_DIR/waybar/setup.sh"
fi

# Setup Wofi
if [ "$INSTALL_TYPE" = "full" ] && [ -f "$DOTFILES_DIR/wofi/setup.sh" ]; then
  bash "$DOTFILES_DIR/wofi/setup.sh"
fi

# Setup git global configuration
git config --global user.name "Andreas Ekström"
git config --global user.email "didair@msn.com"
# Customize these values or move to a separate setup script

echo "Installation completed successfully!"
echo "Please log out and log back in for all changes to take effect."
