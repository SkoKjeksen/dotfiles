#!/bin/bash

# ---- Symlinker!! ----

OMZ_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OMZ_DIR/custom}"
FONT_DIR="$HOME/.local/share/fonts"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔗 Starting Symlinking "

  # Create symlink so 'bat' works
if command -v batcat &>/dev/null; then
  mkdir -p ~/.local/bin
  ln -sf $(which batcat) ~/.local/bin/bat
  echo "🔗 Linked batcat -> bat"
fi


# Create fd symlink if it exists
if command -v fdfind &>/dev/null; then
  mkdir -p ~/.local/bin
  ln -sf $(which fdfind) ~/.local/bin/fd
  echo "🔗 Linked fdfind -> fd"
fi

echo "💾 Applying Dotfiles..."
# Symlink .zshrc from Repo
# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ]; then
  echo "   - Backing up existing .zshrc..."
  mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%s)"
fi
if [ -f "$REPO_DIR/.zshrc" ]; then
  echo "   - Symlinking .zshrc from repo..."
  ln -s "$REPO_DIR/.zshrc" "$HOME/"
else
  echo "⚠️  WARNING: .zshrc not found in script directory!"
fi

# Symlink .p10k.zsh from Repo
if [ -f "$REPO_DIR/.p10k.zsh" ]; then
  echo "   - Symlinking .p10k.zsh from repo..."
  [ -f "$HOME/.p10k.zsh" ] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.backup.$(date +%s)"
  ln -s "$REPO_DIR/.p10k.zsh" "$HOME/"
fi

# Symlink Nvim config
mkdir -p "$HOME/.config"
if [ -d "$HOME/.config/nvim" ]; then
  # Check if it is a real directory (not a symlink)
  if [ ! -L "$HOME/.config/nvim" ]; then
    echo "   - Backing up existing nvim config..."
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
  else
    echo "   - nvim config is already a symlink, skipping backup."
  fi
fi
if [ -d "$REPO_DIR/nvim" ]; then
  if [ ! -e "$HOME/.config/nvim" ]; then
    echo " - Symlinking nvim config..."
    ln -s "$REPO_DIR/nvim" "$HOME/.config/nvim"
  else
    echo " - nvim config already exists"
  fi
else
  echo "⚠️  WARNING: nvim config directory not found in repo!"
fi

# Tmux config symlink
if [ -d "$HOME/.config/tmux" ]; then
  if [ ! -L "$HOME/.config/tmux" ]; then
    echo "   - Backing up existing tmux config..."
    mv "$HOME/.config/tmux" "$HOME/.config/tmux.backup.$(date +%s)"
  else
    echo "   - tmux config is already a symlink, skipping backup."
  fi
fi

if [ -d "$REPO_DIR/tmux" ]; then
  if [ ! -e "$HOME/.config/tmux" ]; then
    echo "   - Symlinking tmux config..."
    ln -s "$REPO_DIR/tmux" "$HOME/.config/tmux"
  else
    echo "   - tmux config already exists"
  fi
else
  echo "⚠️  WARNING: tmux config directory not found in repo!"
fi
