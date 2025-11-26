#!/bin/bash

# Fix 1: Correct Shebang
# Fix 2: Define paths variables
OMZ_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OMZ_DIR/custom}"

echo "🚀 Starting Terminal Setup..."

# --- PRE-CHECK: Ensure dependencies exist ---
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install git first (sudo apt install git)."
    exit 1
fi
if ! command -v curl &> /dev/null; then
    echo "❌ Curl is not installed. Please install curl first (sudo apt install curl)."
    exit 1
fi
if ! command -v zsh &> /dev/null; then
    echo "❌ Zsh is not installed. Please install zsh first (sudo apt install zsh)."
    exit 1
fi

# --- 1. Install Oh My Zsh (FIXED LOGIC) ---
# Check if directory exists BUT the main script is missing (Corrupt install)
if [ -d "$OMZ_DIR" ] && [ ! -f "$OMZ_DIR/oh-my-zsh.sh" ]; then
    echo "⚠️  Detected corrupt Oh My Zsh folder. Removing to reinstall..."
    rm -rf "$OMZ_DIR"
fi

if [ ! -d "$OMZ_DIR" ]; then
    echo "📦 Installing Oh My Zsh..."
    # --unattended keeps the script running without dropping you into the shell immediately
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh is already installed correctly."
fi

# --- 2. Install Powerlevel10k ---
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "🎨 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "✅ Powerlevel10k already installed."
fi

# --- 3. Install Plugins ---
echo "🔌 Installing Plugins..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# --- 4. Install Tools ---
install_if_missing() {
	PACKAGE=$1
	COMMAND=$2
	
	#if the second argument is empy, assume command name = package name
	if [ -z "$COMMAND" ]; then
	COMMAND="$PACKAGE"
	fi
	
	# Check if command exists
	if ! command -v "$COMMAND" &> /dev/null; then
		sudo apt update && sudo apt install -y "$PACKAGE"
	else
		echo "✅ $PACKAGE is already installed."
	fi

}

echo "🚀 Checking utilities..."
	install_if_missing "ripgrep" "rg"

if ! command -v bat &> /dev/null; then
	if command -b batcat &> /dev/null; then
		echo "✅ Bat is installed (as batcat)."

	else 
       		 echo "⬇️  Installing bat..."
       	         sudo apt install -y bat
   	fi
	if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
		echo "🔗 Linking batcat to bat..."
		mkdir -p ~/.local/bin
		ln -s /usr/bin/batcat ~/.local/bin/bat
	fi
else
	echo "✅ Bat is already installed."
fi

if dpkg -s fzf >/dev/null 2>&1; then
    echo "🗑️  Removing old apt version of fzf..."
    sudo apt remove -y fzf
fi

if [ ! -d "$HOME/.fzf" ]; then
    echo "⬇️  Cloning FZF (Latest)..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    echo "⚙️  Installing FZF binary and keybindings..."
    # --all answers "yes" to all questions (keybindings, fuzzy auto-completion, etc.)
    ~/.fzf/install --all
else
    echo "🔄 FZF already exists. Updating..."
    cd ~/.fzf && git pull && ./install --all
fi

# --- 4. Eza (Better ls) ---
# We use the official repo to ensure we get the latest version (with icons/git support)
if ! command -v eza &> /dev/null; then
    echo "⬇️  Installing Eza (Modern ls)..."
    
    # 1. Install necessary dependencies for adding repos
    sudo apt install -y gpg

    # 2. Add the GPG key
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg

    # 3. Add the repo to sources list
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list

    # 4. Update and Install
    sudo apt update
    sudo apt install -y eza
else
    echo "✅ Eza is already installed."
fi


# --- 4. Configure .zshrc ---
echo "💾 configuring .zshrc..."

# Backup existing
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup.$(date +%s)

# Logic: If you have a custom .zshrc in the same folder as this script, copy it.
# Otherwise, we modify the default one created by OMZ.
if [ -f "./.zshrc" ]; then
    echo "📄 Copying local .zshrc to home..."
    cp .zshrc ~/
else
    echo "⚙️  Updating default .zshrc..."
    # 1. Enable plugins
    sed -i -e 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
    # 2. Set Theme to Powerlevel10k
    sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
fi

# Check for p10k config
if [ -f "./.p10k.zsh" ]; then
    cp .p10k.zsh ~/
    # Append p10k source to zshrc if not present
    if ! grep -q "p10k.zsh" ~/.zshrc; then
        echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc
    fi
fi

# --- 5. Install Fonts (Fixed Logic) ---
FONT_DIR=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    FONT_DIR="$HOME/Library/Fonts"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
fi

if [ -n "$FONT_DIR" ]; then
    echo "🔤 Downloading Meslo Nerd Fonts..."
    # Only download if not already there
    if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
        curl -sL -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
        curl -sL -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
        curl -sL -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
        
        # Refresh cache for Linux
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            fc-cache -f -v > /dev/null
        fi
        echo "✅ Fonts installed."
    else
        echo "✅ Fonts already exist."
    fi
else
    echo "⚠️  Skipping fonts (Could not detect OS font path)."
fi

# --- 6. Set Shell ---
if [ "$SHELL" != "$(which zsh)" ]; then 
    echo "🔄 Asking to change default shell to zsh (password may be required)..."
    chsh -s $(which zsh)
fi

echo "🎉 Setup Complete! Close this terminal and open a new one."
