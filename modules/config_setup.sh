#!/bin/bash

# Shell-Pro Configuration Setup Module
# Handles backup and configuration of .zshrc

# Source utilities using cross-compatible path detection
source "$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)/utils.sh"

# Backup existing .zshrc if it exists and is different
backup_existing_config() {
    local SHELL_PRO_DIR="$1"
    
    if [ -f "$HOME/.zshrc" ]; then
        if ! cmp -s "$HOME/.zshrc" "$SHELL_PRO_DIR/.zshrc"; then
            local BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
            print_warning "Backing up existing .zshrc to $(basename "$BACKUP_FILE")"
            cp "$HOME/.zshrc" "$BACKUP_FILE"
        fi
    fi
}

# Setup .zshrc configuration
setup_zshrc_config() {
    local SHELL_PRO_DIR="$1"
    
    print_status "Setting up .zshrc configuration..."
    
    # Create .zshenv to set ZDOTDIR
    echo "export ZDOTDIR=\"$SHELL_PRO_DIR\"" > ~/.zshenv
    
    # Copy .zshrc from Shell-Pro
    ln -sf "$SHELL_PRO_DIR/.zshrc" "$HOME/.zshrc"
    
    print_success ".zshrc configuration applied"
}