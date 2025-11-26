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

# --- 3. Install Themes & Plugins ---
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "🎨 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

echo "🔌 Installing Zsh Plugins..."
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# --- 4. Install Modern Tools ---
# Your .zshrc likely relies on these tools existing.

# FZF (Latest from Git)
if dpkg -s fzf >/dev/null 2>&1; then
    sudo apt remove -y fzf  # Remove old apt version
fi
if [ ! -d "$HOME/.fzf" ]; then
    echo "⬇️  Cloning FZF..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
else
    echo "✅ FZF is ready."
fi

# Ripgrep
if ! command -v rg &> /dev/null; then
    echo "⬇️  Installing Ripgrep..."
    sudo apt install -y ripgrep
fi

# Bat (with batcat -> bat fix)
if ! command -v bat &> /dev/null; then
    if command -v batcat &> /dev/null; then
        echo "✅ Bat is installed (as batcat)."
    else 
        echo "⬇️  Installing bat..."
        sudo apt install -y bat
    fi
    # Create symlink so 'bat' works
    if command -v batcat &> /dev/null; then
        mkdir -p ~/.local/bin
        ln -sf $(which batcat) ~/.local/bin/bat
        echo "🔗 Linked batcat -> bat"
    fi
fi

# Eza (Modern ls)
if ! command -v eza &> /dev/null; then
    echo "⬇️  Installing Eza..."
    sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo apt update && sudo apt install -y eza
fi

# fd (Needed for LazyVim)
if ! command -v fd &> /dev/null; then
    echo "⬇️  Installing fd-find..."
    sudo apt install -y fd-find
    mkdir -p ~/.local/bin
    ln -sf $(which fdfind) ~/.local/bin/fd
fi

# --- 5. Install Neovim & LazyVim ---
if ! command -v nvim &> /dev/null; then
    echo "⬇️  Downloading Neovim (Latest)..."
    sudo curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    sudo chmod a+x nvim-linux-x86_64.appimage
    sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
fi

# DOTFILES LOGIC:
# 1. If you have a 'nvim' folder in your repo, we copy that.
# 2. If not, we install the default LazyVim starter.
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# --- 6. Install Dotfiles (The Core Logic) ---
echo "💾 Applying Dotfiles..."

# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ]; then
    echo "   - Backing up existing .zshrc..."
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%s)"
fi

# Copy .zshrc from Repo
if [ -f "$REPO_DIR/.zshrc" ]; then
    echo "   - Copying .zshrc from repo..."
    cp "$REPO_DIR/.zshrc" "$HOME/"
else
    echo "⚠️  WARNING: .zshrc not found in script directory!"
fi

# Copy .p10k.zsh from Repo
if [ -f "$REPO_DIR/.p10k.zsh" ]; then
    echo "   - Copying .p10k.zsh from repo..."
    [ -f "$HOME/.p10k.zsh" ] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.backup.$(date +%s)"
    cp "$REPO_DIR/.p10k.zsh" "$HOME/"
fi

# --- 7. Install Fonts ---
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    mkdir -p "$FONT_DIR"
    if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
        echo "🔤 Downloading Meslo Nerd Fonts..."
        curl -sL -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
        curl -sL -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
        curl -sL -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
        fc-cache -f -v > /dev/null
    fi
fi

# --- 8. Set Shell ---
if [ "$SHELL" != "$(which zsh)" ]; then 
    echo "🔄 Asking to change default shell to zsh..."
    chsh -s $(which zsh)
fi

echo "🎉 Setup Complete! Restart your terminal."