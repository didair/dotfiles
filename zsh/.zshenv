# ~/.zshenv: Loaded for all shells (login, interactive, scripts)
# Use this file for environment variables that should be set for all zsh sessions

# XDG Base Directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Define ZDOTDIR if you want to store zsh configs elsewhere
# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export BROWSER="firefox"
export TERMINAL="ghostty"

# Default less options
export LESS="-R"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# Man page colors
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Set language and locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# GPG TTY for git commit signing
export GPG_TTY=$(tty)

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;34m'     # begin blink
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\e[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\e[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

# Setup Rust environment if it exists
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Local binaries for Node.js
export PATH="$HOME/.local/share/npm/bin:$PATH"
export npm_config_prefix="$HOME/.local/share/npm"

# Java Home
[ -d "/usr/lib/jvm/default" ] && export JAVA_HOME="/usr/lib/jvm/default"

# Dotfiles directory
export DOTFILES="$HOME/dotfiles"