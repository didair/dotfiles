#!/bin/bash

# Zsh setup script
# Usage: ./zsh/setup.sh [--update]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
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

# Create symbolic links for zsh configuration
echo "Setting up Zsh configuration..."
create_link() {
  local src="$1"
  local dest="$2"
  
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

# Link zsh configuration files
create_link "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
create_link "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  if [ "$UPDATE_MODE" = true ]; then
    echo "Updating Oh My Zsh..."
    # omz update
  fi
fi

# Install/update zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  if [ "$UPDATE_MODE" = true ]; then
    echo "Updating zsh-syntax-highlighting..."
    git -C "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" pull
  fi
fi

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  if [ "$UPDATE_MODE" = true ]; then
    echo "Updating zsh-autosuggestions..."
    git -C "$ZSH_CUSTOM/plugins/zsh-autosuggestions" pull
  fi
fi

# Install powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "Installing powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
  if [ "$UPDATE_MODE" = true ]; then
    echo "Updating powerlevel10k theme..."
    git -C "$ZSH_CUSTOM/themes/powerlevel10k" pull
  fi
fi

# Set Zsh as default shell if it's not already
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting Zsh as default shell..."
  chsh -s "$(which zsh)"
  echo "You may need to log out and log back in for this change to take effect."
fi

echo "Zsh setup completed successfully!"
