#!/bin/bash

# Shell-Pro Oh My Zsh Setup Module
# Handles Oh My Zsh installation

# Source utilities
source "$(dirname "$0")/utils.sh"

# Install Oh My Zsh if not already installed
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed successfully"
    else
        print_success "Oh My Zsh already installed"
    fi
}