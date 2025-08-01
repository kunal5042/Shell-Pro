#!/bin/bash

# Shell-Pro Configuration Teardown Module
# Handles restoration of original configurations

# Source teardown utilities using cross-compatible path detection
source "$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)/teardown_utils.sh"

# Restore original .zshrc from backup
restore_original_zshrc() {
    print_status "Checking for .zshrc backups to restore..."
    
    # Find the most recent backup
    local latest_backup=""
    if ls "$HOME"/.zshrc.backup.* >/dev/null 2>&1; then
        latest_backup=$(ls -t "$HOME"/.zshrc.backup.* | head -n1)
        
        log_action "Restoring backup: $(basename "$latest_backup")"
        if cp "$latest_backup" "$HOME/.zshrc"; then
            print_success "Restored .zshrc from backup: $(basename "$latest_backup")"
        else
            print_error "Failed to restore .zshrc from backup"
        fi
    else
        print_warning "No .zshrc backups found. Removing current .zshrc instead"
        safe_remove "$HOME/.zshrc" ".zshrc"
    fi
}

# Remove Shell-Pro .zshrc if it exists
remove_shell_pro_zshrc() {
    if path_exists "$HOME/.zshrc"; then
        # Check if current .zshrc is from Shell-Pro (contains Shell-Pro references)
        if grep -q "Shell-Pro\|ZDOTDIR.*Shell-Pro" "$HOME/.zshrc" 2>/dev/null; then
            log_action "Removing Shell-Pro .zshrc"
            safe_remove "$HOME/.zshrc" ".zshrc (Shell-Pro version)"
        else
            print_status "Current .zshrc doesn't appear to be from Shell-Pro, removing anyway"
            safe_remove "$HOME/.zshrc" ".zshrc"
        fi
    fi
}

# Remove .zshenv that points to Shell-Pro
remove_shell_pro_zshenv() {
    if path_exists "$HOME/.zshenv"; then
        if grep -q "Shell-Pro" "$HOME/.zshenv" 2>/dev/null; then
            log_action "Removing Shell-Pro .zshenv"
            safe_remove "$HOME/.zshenv" ".zshenv (Shell-Pro ZDOTDIR)"
        else
            print_status ".zshenv doesn't contain Shell-Pro references, removing anyway"
            safe_remove "$HOME/.zshenv" ".zshenv"
        fi
    fi
}

# Clean up all .zshrc backup files created by Shell-Pro
cleanup_zshrc_backups() {
    log_action "Removing all .zshrc backup files"
    local backup_count=0
    for backup in "$HOME"/.zshrc.backup.*; do
        if [ -f "$backup" ]; then
            if rm "$backup" 2>/dev/null; then
                print_success "Removed backup: $(basename "$backup")"
                backup_count=$((backup_count + 1))
            else
                print_warning "Failed to remove backup: $(basename "$backup")"
            fi
        fi
    done
    
    if [ $backup_count -gt 0 ]; then
        print_success "Cleaned up $backup_count backup files"
    else
        print_status "No backup files found to clean up"
    fi
}