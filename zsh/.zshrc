# Zsh Configuration

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Plugins
plugins=(
  git
  docker
  docker-compose
  kubectl
  npm
  python
  pip
  vscode
  zsh-syntax-highlighting
  zsh-autosuggestions
  history-substring-search
  tmux
  copyfile
  copypath
  ssh-agent
)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Enhanced cd
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

# Aliases
alias zshconfig="$EDITOR ~/.zshrc"
alias zshreload="source ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias dotfiles="cd $HOME/dotfiles"

# Vim style
alias vi="nvim"
alias vim="nvim"

# General aliases
alias ls="ls --color=auto"
alias ll="ls -la"
alias la="ls -a"
alias grep="grep --color=auto"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git aliases
alias lg="lazygit"
alias ld="lazydocker"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"
alias glog="git log --oneline --decorate --graph"

# Docker aliases
alias dc="docker compose"
alias dps="docker ps"
alias dpsa="docker ps -a"

# System aliases
alias update="sudo pacman -Syu"
alias updateall="yay -Syu --noconfirm"

# Custom PATH additions
export PATH="$HOME/.local/bin:$PATH"

# NVM (Node Version Manager) setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Rust
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Python
export PYTHONDONTWRITEBYTECODE=1  # Don't create .pyc files

# FZF (Fuzzy Finder) integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load local configuration if it exists
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Function to update dotfiles
update_dotfiles() {
  local dotfiles_dir="$HOME/dotfiles"
  if [ -d "$dotfiles_dir" ]; then
    echo "Updating dotfiles..."
    (cd "$dotfiles_dir" && ./update.sh --pull "$@")
  else
    echo "Dotfiles directory not found at $dotfiles_dir"
  fi
}

# Function to create a new directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Function to extract various archive types
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


PATH=~/.console-ninja/.bin:$PATH