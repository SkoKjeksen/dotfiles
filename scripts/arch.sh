
#!/usr/bin/env bash
set -e

echo "Installing system dependencies..."

sudo pacman -Syu --needed

sudo pacman -S --needed \
    git \
    curl \
    wget \
    zsh \
    base-devel \
    unzip \
    cmake \
    fuse2 \
    bat \
    fd \
    fzf \
    ripgrep \
    eza \
    clang \
    luarocks \
    tmux \
    neovim \
    nodejs \
    npm \
    lazygit \
    pipx

# Oh My Zsh
OMZ_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OMZ_DIR/custom}"

if [ ! -f "$OMZ_DIR/oh-my-zsh.sh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Powerlevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 \
        https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Zsh plugins
mkdir -p "$ZSH_CUSTOM/plugins"

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
        git clone "https://github.com/zsh-users/$plugin.git" \
            "$ZSH_CUSTOM/plugins/$plugin"
    fi
done

# PlatformIO
if ! command -v pio &>/dev/null; then
    pipx install platformio
fi

# FZF integration
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
fi

echo "Installation complete!"
