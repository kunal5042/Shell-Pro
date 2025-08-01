#!/bin/bash

# Shell-Pro Oh My Zsh Setup Module
# Handles Oh My Zsh installation

# Source utilities using cross-compatible path detection
source "$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)/utils.sh"

# Install Oh My Zsh if not already installed
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        
        # Temporarily move existing .zshrc to prevent Oh My Zsh from overwriting it
        local temp_zshrc=""
        if [ -f "$HOME/.zshrc" ]; then
            temp_zshrc="$HOME/.zshrc.temp.$(date +%s)"
            mv "$HOME/.zshrc" "$temp_zshrc"
            print_status "Temporarily moved existing .zshrc to prevent overwrite"
        fi
        
        # Install Oh My Zsh
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        # Remove any .zshrc that Oh My Zsh created
        if [ -f "$HOME/.zshrc" ]; then
            rm -f "$HOME/.zshrc"
            print_status "Removed Oh My Zsh template .zshrc"
        fi
        
        # Restore our original .zshrc if it existed
        if [ -n "$temp_zshrc" ] && [ -f "$temp_zshrc" ]; then
            mv "$temp_zshrc" "$HOME/.zshrc"
            print_status "Restored original .zshrc"
        fi
        
        print_success "Oh My Zsh installed successfully (without overwriting .zshrc)"
    else
        print_success "Oh My Zsh already installed"
    fi
}