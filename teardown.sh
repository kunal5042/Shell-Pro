#!/bin/bash

# Shell-Pro Teardown Script
# Completely removes Shell-Pro and restores your system to its original state

set -e  # Exit on any error

# Get the directory where this script is located (Shell-Pro directory)
SHELL_PRO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source teardown utilities
source "$SHELL_PRO_DIR/teardown_modules/teardown_utils.sh"

echo "🧹 Shell-Pro Teardown Script"
echo "=============================="
echo ""

print_error "⚠️  AUTOMATIC TEARDOWN MODE ⚠️"
print_error "This script will AUTOMATICALLY and COMPLETELY remove Shell-Pro!"
echo ""
print_warning "🔥 WHAT WILL BE DELETED (NO QUESTIONS ASKED):"
echo "  • ALL Shell-Pro .zshrc and .zshenv configurations"
echo "  • Oh My Zsh installation and ALL configurations"
echo "  • All backup files created by Shell-Pro"
echo "  • Default shell will be restored (if changed to zsh)"
echo "  • The ENTIRE Shell-Pro repository and all files"
echo "  • All custom themes and plugins"
echo ""
print_error "⚠️  This action CANNOT be undone!"
print_error "⚠️  Font cleanup guidance will be provided but fonts won't be auto-removed"
echo ""

print_status "🚀 Starting automatic teardown in 3 seconds..."
sleep 1 && echo "3..." 
sleep 1 && echo "2..." 
sleep 1 && echo "1..." 
echo ""
print_status "🔥 TEARDOWN INITIATED - NO TURNING BACK!"

echo ""
print_status "Shell-Pro directory: $SHELL_PRO_DIR"
echo ""

# Source all teardown modules
source "$SHELL_PRO_DIR/teardown_modules/config_teardown.sh"
source "$SHELL_PRO_DIR/teardown_modules/ohmyzsh_teardown.sh"
source "$SHELL_PRO_DIR/teardown_modules/shell_teardown.sh"
source "$SHELL_PRO_DIR/teardown_modules/fonts_teardown.sh"
source "$SHELL_PRO_DIR/teardown_modules/repo_teardown.sh"

echo "🔄 Starting teardown process..."
echo ""

# Step 1: Handle configuration files
print_status "Step 1: Restoring original configurations..."
remove_shell_pro_zshenv
remove_shell_pro_zshrc
restore_original_zshrc
echo ""

# Step 2: Handle Oh My Zsh
print_status "Step 2: Oh My Zsh cleanup..."
remove_oh_my_zsh
remove_oh_my_zsh_cache
echo ""

# Step 3: Restore original shell
print_status "Step 3: Shell configuration..."
restore_original_shell
note_about_zsh_removal
echo ""

# Step 4: Font guidance
print_status "Step 4: Font cleanup guidance..."
check_font_usage
provide_font_cleanup_guidance
echo ""

# Step 5: Clean up backup files
print_status "Step 5: Backup file cleanup..."
cleanup_zshrc_backups
echo ""

# Step 6: Check for remaining references
print_status "Step 6: Final cleanup check..."
cleanup_shell_pro_references
echo ""

# Final step: Remove the repository itself
print_status "Step 7: Repository removal..."
remove_shell_pro_repository "$SHELL_PRO_DIR"

# This line will only execute if the repository removal failed
# If successful, the script ends when the repository is deleted
print_status "Restart your terminal to ensure all changes take effect"
print_success "Thank you for using Shell-Pro, hope you enjoyed it!"
print_success "Taking you back to old age..."
sh