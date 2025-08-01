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

print_warning "This script will completely remove Shell-Pro and attempt to restore your system"
print_warning "to its state before Shell-Pro was installed."
echo ""
print_status "What this script will do:"
echo "  • Restore original .zshrc from backup (if available)"
echo "  • Remove Shell-Pro .zshrc and .zshenv configurations"
echo "  • Remove Oh My Zsh installation (with confirmation)"
echo "  • Restore original default shell (if changed to zsh)"
echo "  • Clean up backup files created by Shell-Pro"
echo "  • Provide guidance for font cleanup"
echo "  • Remove the entire Shell-Pro repository (final step)"
echo ""
print_warning "⚠️  Some changes (like installed fonts) may require manual cleanup"
echo ""

if ! confirm_action "Do you want to proceed with the Shell-Pro teardown?"; then
    print_status "Teardown cancelled. No changes were made."
    exit 0
fi

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
if remove_shell_pro_repository "$SHELL_PRO_DIR"; then
    # This will only run if repository removal was cancelled
    echo ""
    print_success "Teardown completed (repository preserved)"
    print_status "If you want to remove the repository later, you can manually delete: $SHELL_PRO_DIR"
    echo ""
    print_status "Restart your terminal to ensure all changes take effect"
else
    # Script will end here if repository was successfully removed
    echo "Script completed"
fi