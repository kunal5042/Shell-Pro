#!/bin/bash

# Shell-Pro Oh My Zsh Teardown Module
# Handles removal of Oh My Zsh installation

# Source teardown utilities
source "$(dirname "$0")/teardown_utils.sh"

# Remove Oh My Zsh installation
remove_oh_my_zsh() {
    local ohmyzsh_dir="$HOME/.oh-my-zsh"
    
    if path_exists "$ohmyzsh_dir"; then
        if confirm_action "Remove Oh My Zsh installation? This will remove all Oh My Zsh configurations and plugins."; then
            # Check if Oh My Zsh has an uninstall script
            local uninstall_script="$ohmyzsh_dir/tools/uninstall.sh"
            
            if [ -f "$uninstall_script" ]; then
                print_status "Using Oh My Zsh official uninstall script..."
                if confirm_action "Run Oh My Zsh uninstall script? (Recommended)"; then
                    # Run the official uninstaller
                    sh "$uninstall_script" --unattended 2>/dev/null || {
                        print_warning "Official uninstaller failed, proceeding with manual removal"
                        safe_remove "$ohmyzsh_dir" "Oh My Zsh directory"
                    }
                else
                    # Manual removal
                    safe_remove "$ohmyzsh_dir" "Oh My Zsh directory"
                fi
            else
                # Manual removal if uninstall script doesn't exist
                safe_remove "$ohmyzsh_dir" "Oh My Zsh directory"
            fi
        else
            print_status "Keeping Oh My Zsh installation"
        fi
    else
        print_status "Oh My Zsh not found, nothing to remove"
    fi
}

# Remove Oh My Zsh cache files
remove_oh_my_zsh_cache() {
    local cache_dirs=(
        "$HOME/.oh-my-zsh-cache"
        "$HOME/.cache/oh-my-zsh"
        "$ZSH_CACHE_DIR"
    )
    
    for cache_dir in "${cache_dirs[@]}"; do
        if [ -n "$cache_dir" ] && path_exists "$cache_dir"; then
            safe_remove "$cache_dir" "Oh My Zsh cache directory"
        fi
    done
}