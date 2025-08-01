#!/bin/bash

# Shell-Pro Configuration Setup Module
# Handles backup and configuration of .zshrc

# Source utilities using cross-compatible path detection
source "$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)/utils.sh"

# Backup existing .zshrc if it exists and is different
backup_existing_config() {
    local SHELL_PRO_DIR="$1"
    
    if [ -f "$HOME/.zshrc" ]; then
        # Check if current .zshrc is different from Shell-Pro's version
        if ! cmp -s "$HOME/.zshrc" "$SHELL_PRO_DIR/.zshrc"; then
            local BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
            
            # Check if it's an Oh My Zsh template (contains Oh My Zsh specific content)
            if grep -q "oh-my-zsh\|robbyrussell" "$HOME/.zshrc" 2>/dev/null; then
                print_warning "Found Oh My Zsh template .zshrc, backing up to $(basename "$BACKUP_FILE")"
            else
                print_warning "Found custom .zshrc, backing up to $(basename "$BACKUP_FILE")"
            fi
            cp "$HOME/.zshrc" "$BACKUP_FILE"
        else
            print_status "Current .zshrc is already Shell-Pro version, no backup needed"
        fi
    else
        print_status "No existing .zshrc found, will create new one"
    fi
}

# Setup .zshrc configuration
setup_zshrc_config() {
    local SHELL_PRO_DIR="$1"
    
    print_status "Setting up .zshrc configuration..."
    
    # Create .zshenv to set ZDOTDIR
    echo "export ZDOTDIR=\"$SHELL_PRO_DIR\"" > ~/.zshenv
    
    # Always use Shell-Pro's custom .zshrc, overwriting any Oh My Zsh template
    print_status "Applying Shell-Pro's custom .zshrc configuration..."
    cp "$SHELL_PRO_DIR/.zshrc" "$HOME/.zshrc"
    
    print_success ".zshrc configuration applied (custom Shell-Pro version)"
}