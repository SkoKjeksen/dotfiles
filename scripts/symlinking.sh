#!/bin/bash

# ---- Symlinker!! ----

OMZ_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OMZ_DIR/custom}"
FONT_DIR="$HOME/.local/share/fonts"
REPO_DIR="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)"

echo "Starting Symlinking "

# Create symlink so 'bat' works
if command -v batcat &>/dev/null; then
    mkdir -p ~/.local/bin
    ln -sf $(which batcat) ~/.local/bin/bat
    echo "Linked batcat -> bat"
fi

# Create fd symlink if it exists
if command -v fdfind &>/dev/null; then
    mkdir -p ~/.local/bin
    ln -sf $(which fdfind) ~/.local/bin/fd
    echo "Linked fdfind -> fd"
fi

echo "Applying Dotfiles..."
link_dotfile() {
    local source="$1"
    local target="$2"

    if [ ! -f "$source" ]; then
        echo "WARNING: $source not found!"
        return 1
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ "$target" -ef "$source" ]; then
            echo " - $target already links to $source"
            return 0
        fi
        echo " - Backing up $target..."
        mv "$target" "$target.backup.$(date +%s)"
    fi

    ln -s "$source" "$target"
    echo " - Linked $target to $source"
}

link_dotfile "$REPO_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_dotfile "$REPO_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link_dotfile "$REPO_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"

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
    echo " WARNING: nvim config directory not found in repo!"
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
    echo "WARNING: tmux config directory not found in repo!"
fi

# Clangd config
if [ -d "$REPO_DIR/clangd" ]; then
    if [ ! -e "$HOME/.config/clangd" ]; then
        echo " - Symlinking Clangd config..."
        ln -s "$REPO_DIR/clangd" "$HOME/.config/clangd"
    else
        echo " - Clangd config already exists"
    fi
    # Clang format
    if [ ! -e "$HOME/.clang-format" ]; then
        echo " - Symlinking Clangd format..."
        ln -s "$REPO_DIR/clangd/.clang-format" "$HOME/.clang-format"
    else
        echo " - Clang format already exists"
    fi
else
    echo "WARNING: Clangd config directory not found in repo!"
fi
