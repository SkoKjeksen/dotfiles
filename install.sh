!#/bin/bash

echo "🚀 Starting Terminal Setup..."

# 1. Install Oh My Zsh (if not already installed)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh is already installed"
fi

# 2. Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "🎨 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# 3. Install Plugins (Autosuggestions & Syntax Highlighting)
echo "🔌 Installing Plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || echo "   - Autosuggestions already installed"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || echo "   - Syntax Highlighting already installed"

# 4. Backup existing config and copy new ones
echo "💾 Backing up old config..."
mv ~/.zshrc ~/.zshrc.backup.$(date +%s) 2>/dev/null
mv ~/.p10k.zsh ~/.p10k.zsh.backup.$(date +%s) 2>/dev/null

echo "📄 Copying new configuration..."
cp .zshrc ~/
cp .p10k.zsh ~/

# 5. Install Fonts (MesloLGS NF)
echo "abc" > test_font_permission
if [ -w /Library/Fonts ]; then
    FONT_DIR="$HOME/Library/Fonts" # MacOS
elif [ -w ~/.local/share/fonts ]; then
    FONT_DIR="$HOME/.local/share/fonts" # Linux
    mkdir -p $FONT_DIR
else
    echo "⚠️  Could not detect font directory. Skipping font download."
    FONT_DIR=""
fi

if [ -n "$FONT_DIR" ]; then
    echo "abc" > $FONT_DIR/write_test 2>/dev/null
    if [ $? -eq 0 ]; then
        rm $FONT_DIR/write_test
        echo "🔤 Downloading Meslo Nerd Fonts to $FONT_DIR..."
        curl -L -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
        curl -L -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
        curl -L -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
        
        # Refresh font cache for Linux
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            fc-cache -f -v
        fi
        echo "✅ Fonts installed!"
    else
         echo "⚠️  No write permission for fonts. You may need to install them manually."
    fi
fi

echo "🎉 Setup Complete! Restart your terminal."
echo "⚠️  IMPORTANT: Open your Terminal Preferences and change the font to 'MesloLGS NF'."
