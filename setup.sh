#!/bin/bash

# Shell-Pro Setup Script
# Automated setup for your shell environment on any new machine
# Modular version - orchestrates all setup modules

set -e  # Exit on any error

# Get the directory where this script is located (Shell-Pro directory)
SHELL_PRO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SHELL_PRO_DIR/modules/utils.sh"

echo "🚀 Setting up Shell-Pro environment..."
print_status "Shell-Pro directory: $SHELL_PRO_DIR"

# Source all setup modules
source "$SHELL_PRO_DIR/modules/zsh_setup.sh"
source "$SHELL_PRO_DIR/modules/ohmyzsh_setup.sh"
source "$SHELL_PRO_DIR/modules/plugins_setup.sh"
source "$SHELL_PRO_DIR/modules/config_setup.sh"
source "$SHELL_PRO_DIR/modules/fonts_setup.sh"

# 1. Ensure zsh is installed and switch to it if needed
print_status "Checking zsh installation..."
check_and_install_zsh
check_and_switch_to_zsh

# 2. Install Oh My Zsh if not already installed
install_oh_my_zsh

# 3. Verify custom plugins and themes are available
verify_plugins_and_themes "$SHELL_PRO_DIR"

# 4. Backup existing .zshrc if it exists and is different
backup_existing_config "$SHELL_PRO_DIR"

# 5. Link or copy the .zshrc file
setup_zshrc_config "$SHELL_PRO_DIR"

# 6. Install required fonts (platform-specific)
install_nerd_fonts

# 7. Set zsh as default shell if not already
setup_default_shell

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

echo "🔄 Restarting terminal..."
print_success "Ampliying your terminal experience..."
print_success "Enjoy!, thank to @kunalwadhwa"
zsh