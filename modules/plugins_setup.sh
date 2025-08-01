#!/bin/bash

# Shell-Pro Plugins and Themes Setup Module
# Handles verification of custom plugins and themes

# Source utilities
source "$(dirname "$0")/utils.sh"

# Verify custom plugins and themes are available
verify_plugins_and_themes() {
    local SHELL_PRO_DIR="$1"
    
    print_status "Verifying custom plugins and themes..."

    # Check Powerlevel10k theme
    local P10K_DIR="$SHELL_PRO_DIR/.zsh/themes/powerlevel10k"
    if [ -f "$P10K_DIR/powerlevel10k.zsh-theme" ]; then
        print_success "Powerlevel10k theme found in repo"
    else
        print_error "Powerlevel10k theme missing from repo. Please ensure .zsh/themes/powerlevel10k exists."
        exit 1
    fi

    # Check zsh-autosuggestions plugin
    local ZSH_AUTOSUGG_DIR="$SHELL_PRO_DIR/.zsh/plugins/zsh-autosuggestions"
    if [ -f "$ZSH_AUTOSUGG_DIR/zsh-autosuggestions.plugin.zsh" ]; then
        print_success "zsh-autosuggestions plugin found in repo"
    else
        print_error "zsh-autosuggestions plugin missing from repo. Please ensure .zsh/plugins/zsh-autosuggestions exists."
        exit 1
    fi
}