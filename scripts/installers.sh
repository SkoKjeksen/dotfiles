#!/bin/bash

OMZ_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OMZ_DIR/custom}"
FONT_DIR="$HOME/.local/share/fonts"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---Program installer! ---

# --- 1. System Dependencies (Debian/Ubuntu) ---
echo "🛠️  Checking system dependencies..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo apt update
  # build-essential & unzip are required for Neovim/LazyVim functionality
  sudo apt install -y git curl zsh build-essential unzip
fi

# --- 2. Install Oh My Zsh ---
# We install this FIRST so it creates the folder structure.
# We will overwrite its default .zshrc later with yours.
if [ -d "$OMZ_DIR" ] && [ ! -f "$OMZ_DIR/oh-my-zsh.sh" ]; then
  echo "⚠️  Corrupt Oh My Zsh found. Reinstalling..."
  rm -rf "$OMZ_DIR"
fi

if [ ! -d "$OMZ_DIR" ]; then
  echo "📦 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh is already installed."
fi

echo "🔌 Installing Zsh Plugins..."
# --- 3. Install Themes & Plugins ---
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# --- 4. Install Modern Tools ---

# Bat (with batcat -> bat fix)
if ! command -v bat &>/dev/null; then
  if command -v batcat &>/dev/null; then
    echo "✅ Bat is installed (as batcat)."
  else
    echo "⬇️  Installing bat..."
    sudo apt install -y bat
  fi
fi

# fd-find (Needed for LazyVim)
if ! command -v fd &>/dev/null && ! command -v fdfind &>/dev/null; then
  echo "⬇️  Installing fd-find..."
  sudo apt install -y fd-find
fi

# FZF (Latest from Git)
if dpkg -s fzf >/dev/null 2>&1; then
  sudo apt remove -y fzf # Remove old apt version
fi
if [ ! -d "$HOME/.fzf" ]; then
  echo "⬇️  Cloning FZF..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
else
  echo "✅ FZF is ready."
fi

# Ripgrep
if ! command -v rg &>/dev/null; then
  echo "⬇️  Installing Ripgrep..."
  sudo apt install -y ripgrep
fi

# Eza (Modern ls)
if ! command -v eza &>/dev/null; then
  echo "⬇️  Installing Eza..."
  sudo apt install -y gpg
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo apt update && sudo apt install -y eza
fi

# install clangd
if ! command -v clangd &>/dev/null; then
  echo "Installing Clangd"
  sudo apt install -y clang-tools
fi

# install tmux
if ! command -v tmux &>/dev/null; then
  echo "⬇️  Installing tmux..."
  sudo apt install -y tmux
fi

# install Neovim & LazyVim ---
if ! command -v nvim &>/dev/null; then
  echo "⬇️  Downloading Neovim (Latest)..."
  sudo curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  sudo chmod a+x nvim-linux-x86_64.appimage
  sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
fi
