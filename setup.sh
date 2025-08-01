#!/bin/bash

# Shell-Pro Setup Script
# Automated setup for your shell environment on any new machine

set -e  # Exit on any error

echo "🚀 Setting up Shell-Pro environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where this script is located (Shell-Pro directory)
SHELL_PRO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_status "Shell-Pro directory: $SHELL_PRO_DIR"

# Check if zsh is installed and install if needed
check_and_install_zsh() {
    if ! command -v zsh >/dev/null 2>&1; then
        print_warning "zsh is not installed. Installing zsh..."
        
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            if command -v brew >/dev/null 2>&1; then
                brew install zsh
                print_success "zsh installed via Homebrew"
            else
                print_error "Homebrew not found. Please install Homebrew first or install zsh manually"
                exit 1
            fi
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            if command -v apt >/dev/null 2>&1; then
                # Debian/Ubuntu
                sudo apt update && sudo apt install -y zsh
                print_success "zsh installed via apt"
            elif command -v yum >/dev/null 2>&1; then
                # RHEL/CentOS/Fedora (older)
                sudo yum install -y zsh
                print_success "zsh installed via yum"
            elif command -v dnf >/dev/null 2>&1; then
                # Fedora (newer)
                sudo dnf install -y zsh
                print_success "zsh installed via dnf"
            elif command -v pacman >/dev/null 2>&1; then
                # Arch Linux
                sudo pacman -S --noconfirm zsh
                print_success "zsh installed via pacman"
            else
                print_error "No supported package manager found. Please install zsh manually"
                exit 1
            fi
        else
            print_error "Unknown OS type: $OSTYPE. Please install zsh manually"
            exit 1
        fi
    else
        print_success "zsh is already installed"
    fi
}

# Check current shell and restart in zsh if needed
check_and_switch_to_zsh() {
    # Check if we're running in bash and zsh is available
    if [ -n "$BASH_VERSION" ] && command -v zsh >/dev/null 2>&1; then
        print_status "Script was run from bash. Switching to zsh..."
        export SHELL="$(which zsh)"
        exec zsh "$0" "$@"
    elif [ -z "$ZSH_VERSION" ] && [ -z "$BASH_VERSION" ]; then
        print_warning "Running in unknown shell. Attempting to switch to zsh..."
        if command -v zsh >/dev/null 2>&1; then
            export SHELL="$(which zsh)"
            exec zsh "$0" "$@"
        fi
    fi
}

# 0. Ensure zsh is installed and switch to it if needed
print_status "Checking zsh installation..."
check_and_install_zsh
check_and_switch_to_zsh

# 1. Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed successfully"
else
    print_success "Oh My Zsh already installed"
fi

# 2. Verify custom plugins and themes are available
print_status "Verifying custom plugins and themes..."

P10K_DIR="$SHELL_PRO_DIR/.zsh/themes/powerlevel10k"
if [ -f "$P10K_DIR/powerlevel10k.zsh-theme" ]; then
    print_success "Powerlevel10k theme found in repo"
else
    print_error "Powerlevel10k theme missing from repo. Please ensure .zsh/themes/powerlevel10k exists."
    exit 1
fi

ZSH_AUTOSUGG_DIR="$SHELL_PRO_DIR/.zsh/plugins/zsh-autosuggestions"
if [ -f "$ZSH_AUTOSUGG_DIR/zsh-autosuggestions.plugin.zsh" ]; then
    print_success "zsh-autosuggestions plugin found in repo"
else
    print_error "zsh-autosuggestions plugin missing from repo. Please ensure .zsh/plugins/zsh-autosuggestions exists."
    exit 1
fi

# 4. Backup existing .zshrc if it exists and is different
if [ -f "$HOME/.zshrc" ]; then
    if ! cmp -s "$HOME/.zshrc" "$SHELL_PRO_DIR/.zshrc"; then
        print_warning "Backing up existing .zshrc to .zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    fi
fi

# 5. Link or copy the .zshrc file
print_status "Setting up .zshrc configuration..."
echo "export ZDOTDIR=\"$SHELL_PRO_DIR\"" > ~/.zshenv
cp "$SHELL_PRO_DIR/.zshrc" "$HOME/.zshrc"
print_success ".zshrc configuration applied"

# 6. Install required fonts (platform-specific)
print_status "Checking for Nerd Fonts (required for Powerlevel10k)..."

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew >/dev/null 2>&1; then
        print_status "Installing Nerd Fonts via Homebrew..."
        brew tap homebrew/cask-fonts 2>/dev/null || true
        brew install --cask font-meslo-lg-nerd-font 2>/dev/null || print_warning "Font installation failed or already installed"
    else
        print_warning "Homebrew not found. Please install Nerd Fonts manually:"
        print_warning "Visit: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    print_status "Attempting to install Nerd Fonts on Linux..."
    
    # Try different package managers
    if command -v apt >/dev/null 2>&1; then
        # Debian/Ubuntu
        sudo apt update && sudo apt install -y fonts-powerline 2>/dev/null || print_warning "Font installation via apt failed"
    elif command -v yum >/dev/null 2>&1; then
        # RHEL/CentOS/Fedora (older)
        sudo yum install -y powerline-fonts 2>/dev/null || print_warning "Font installation via yum failed"
    elif command -v dnf >/dev/null 2>&1; then
        # Fedora (newer)
        sudo dnf install -y powerline-fonts 2>/dev/null || print_warning "Font installation via dnf failed"
    elif command -v pacman >/dev/null 2>&1; then
        # Arch Linux
        sudo pacman -S --noconfirm powerline-fonts 2>/dev/null || print_warning "Font installation via pacman failed"
    else
        print_warning "No supported package manager found for automatic font installation"
    fi
    
    print_warning "For best results, manually install Meslo Nerd Font:"
    print_warning "Visit: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"
else
    print_warning "Unknown OS type: $OSTYPE"
    print_warning "Please install Nerd Fonts manually:"
    print_warning "Visit: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"
fi

# 7. Set zsh as default shell if not already
ZSH_PATH="$(which zsh)"
CURRENT_DEFAULT_SHELL="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)"
if [ -z "$CURRENT_DEFAULT_SHELL" ]; then
    # Fallback for systems without getent (like macOS)
    CURRENT_DEFAULT_SHELL="$SHELL"
fi

if [ "$CURRENT_DEFAULT_SHELL" != "$ZSH_PATH" ]; then
    print_status "Setting zsh as default shell..."
    if command -v chsh >/dev/null 2>&1; then
        if chsh -s "$ZSH_PATH" 2>/dev/null; then
            print_success "Default shell changed to zsh (restart terminal to take effect)"
        else
            print_warning "Failed to change default shell. You may need to:"
            print_warning "1. Add zsh to /etc/shells: echo '$ZSH_PATH' | sudo tee -a /etc/shells"
            print_warning "2. Then run: chsh -s '$ZSH_PATH'"
        fi
    else
        print_warning "Could not change default shell automatically. Please run: chsh -s $ZSH_PATH"
    fi
else
    print_success "zsh is already the default shell"
fi

echo ""
echo "🎉 Shell-Pro setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc"
echo "   2. If this is your first time with Powerlevel10k, run: p10k configure"
echo "   3. Enjoy your enhanced shell experience!"
echo ""
echo "📂 Your Shell-Pro directory: $SHELL_PRO_DIR"
echo "📝 Custom configurations: $SHELL_PRO_DIR/.zsh/"
echo ""