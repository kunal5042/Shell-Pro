#!/bin/bash

# Shell-Pro Oh My Zsh Teardown Module
# Handles removal of Oh My Zsh installation

# Source teardown utilities using cross-compatible path detection
source "$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)/teardown_utils.sh"

# Remove Oh My Zsh installation
remove_oh_my_zsh() {
    local ohmyzsh_dir="$HOME/.oh-my-zsh"
    
    if path_exists "$ohmyzsh_dir"; then
        log_action "Removing Oh My Zsh installation and all configurations"
        
        # Always use manual removal for complete cleanup
        print_status "Using direct removal for complete cleanup..."
        safe_remove "$ohmyzsh_dir" "Oh My Zsh directory"
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