#!/bin/bash

# Shell-Pro Repository Teardown Module
# Handles removal of the Shell-Pro repository itself

# Source teardown utilities
source "$(dirname "$0")/teardown_utils.sh"

# Remove the entire Shell-Pro repository
remove_shell_pro_repository() {
    local SHELL_PRO_DIR="$1"
    
    if [ -z "$SHELL_PRO_DIR" ]; then
        print_error "Shell-Pro directory not specified"
        return 1
    fi
    
    if ! path_exists "$SHELL_PRO_DIR"; then
        print_status "Shell-Pro directory not found: $SHELL_PRO_DIR"
        return 0
    fi
    
    echo ""
    print_warning "🗑️  FINAL STEP: Complete Repository Removal"
    echo ""
    print_status "This will permanently delete the entire Shell-Pro repository:"
    print_status "  📂 Directory: $SHELL_PRO_DIR"
    print_status "  📝 All setup scripts and configurations"
    print_status "  🔧 All custom themes and plugins"
    print_status "  📋 This teardown script itself"
    echo ""
    print_error "⚠️  This action CANNOT be undone!"
    echo ""
    
    if confirm_action "Are you absolutely sure you want to delete the entire Shell-Pro repository?"; then
        # Change to parent directory to avoid deleting from within the directory
        local parent_dir="$(dirname "$SHELL_PRO_DIR")"
        cd "$parent_dir" 2>/dev/null || {
            print_error "Cannot navigate to parent directory"
            return 1
        }
        
        # Double confirmation for safety
        echo ""
        print_error "⚠️  LAST CHANCE: About to permanently delete: $SHELL_PRO_DIR"
        if confirm_action "Type 'yes' to confirm complete removal"; then
            print_status "Removing Shell-Pro repository..."
            
            # Use safe_remove function
            if safe_remove "$SHELL_PRO_DIR" "Shell-Pro repository"; then
                echo ""
                print_success "🎉 Shell-Pro repository completely removed!"
                print_success "Your system has been restored to its pre-Shell-Pro state"
                echo ""
                print_status "Thank you for using Shell-Pro! 👋"
                echo ""
                return 0
            else
                print_error "Failed to remove Shell-Pro repository"
                print_status "You may need to manually remove: $SHELL_PRO_DIR"
                return 1
            fi
        else
            print_status "Repository removal cancelled"
            return 1
        fi
    else
        print_status "Repository removal cancelled"
        return 1
    fi
}

# Clean up any remaining Shell-Pro references
cleanup_shell_pro_references() {
    print_status "Checking for any remaining Shell-Pro references..."
    
    # Check common shell configuration files for Shell-Pro references
    local config_files=(
        "$HOME/.bashrc"
        "$HOME/.bash_profile"
        "$HOME/.profile"
        "$HOME/.zprofile"
        "$HOME/.config/shell/config"
    )
    
    local found_references=false
    for config in "${config_files[@]}"; do
        if [ -f "$config" ] && grep -q "Shell-Pro" "$config" 2>/dev/null; then
            print_warning "Found Shell-Pro reference in: $config"
            print_status "You may want to manually review and clean this file"
            found_references=true
        fi
    done
    
    if [ "$found_references" = false ]; then
        print_success "No remaining Shell-Pro references found in common configuration files"
    fi
}