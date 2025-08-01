#!/bin/bash

# Shell-Pro Shell Configuration Teardown Module
# Handles restoration of original default shell

# Source teardown utilities using cross-compatible path detection
source "$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)/teardown_utils.sh"

# Get the original shell before Shell-Pro was installed
get_original_shell() {
    # Common default shells to check for
    local common_shells=("/bin/bash" "/usr/bin/bash" "/bin/sh" "/usr/bin/sh")
    
    for shell in "${common_shells[@]}"; do
        if [ -x "$shell" ]; then
            echo "$shell"
            return 0
        fi
    done
    
    # Fallback to bash if available
    if command_exists bash; then
        which bash
        return 0
    fi
    
    # Ultimate fallback to sh
    echo "/bin/sh"
}

# Restore original default shell
restore_original_shell() {
    local current_shell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)"
    
    if [ -z "$current_shell" ]; then
        # Fallback for systems without getent (like macOS)
        current_shell="$SHELL"
    fi
    
    # Check if current shell is zsh
    if [[ "$current_shell" == *"zsh"* ]]; then
        local original_shell
        original_shell="$(get_original_shell)"
        
        log_action "Changing default shell from zsh back to $original_shell"
        
        if command_exists chsh; then
            if chsh -s "$original_shell" 2>/dev/null; then
                print_success "Default shell changed to $original_shell"
                print_status "You may need to restart your terminal for changes to take effect"
            else
                print_warning "Failed to change default shell automatically"
                print_warning "You can manually change it by running: chsh -s $original_shell"
            fi
        else
            print_warning "chsh command not available"
            print_warning "You can manually change your default shell to: $original_shell"
        fi
    else
        print_status "Default shell is not zsh, no changes needed"
    fi
}

# Note about zsh uninstallation
note_about_zsh_removal() {
    if command_exists zsh; then
        print_status "Note: zsh itself was NOT removed as it might be used by other applications"
        print_status "If you want to remove zsh completely, you can do so manually:"
        
        if [[ "$OSTYPE" == "darwin"* ]]; then
            if command_exists brew; then
                print_status "  brew uninstall zsh"
            fi
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command_exists apt; then
                print_status "  sudo apt remove zsh"
            elif command_exists yum; then
                print_status "  sudo yum remove zsh"
            elif command_exists dnf; then
                print_status "  sudo dnf remove zsh"
            elif command_exists pacman; then
                print_status "  sudo pacman -R zsh"
            fi
        fi
    fi
}