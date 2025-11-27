#!/bin/bash

# ==========================================
# 🚀 DOTFILES INSTALLER
# ==========================================

# Define paths
OMZ_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OMZ_DIR/custom}"
FONT_DIR="$HOME/.local/share/fonts"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Starting Dotfiles Setup..."

# Install the programs
if [ -x "./scripts/installers.sh" ]; then
  echo "⚙️  Running installers script..."
  ./scripts/installers.sh
else
  echo "⚠️  Installers script not found or not executable!"
  exit 1
fi

# Call symlinking script
if [ -x "./scripts/symlinking.sh" ]; then
  ./scripts/symlinking.sh
else
  echo "⚠️  ERROR: scripts/symlinking.sh not found or not executable"
  exit 1
fi

# --- 7. Install Fonts ---
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  mkdir -p "$FONT_DIR"
  if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    echo "🔤 Downloading Meslo Nerd Fonts..."
    curl -sL -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    curl -sL -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
    curl -sL -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
    fc-cache -f -v >/dev/null
  fi
fi

# --- 8. Set Shell ---
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🔄 Asking to change default shell to zsh..."
  chsh -s $(which zsh)
fi

echo "🎉 Setup Complete! Restart your terminal."
