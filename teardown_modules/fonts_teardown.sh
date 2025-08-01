#!/bin/bash

# Shell-Pro Fonts Teardown Module
# Provides guidance for font cleanup (fonts are tricky to auto-remove)

# Source teardown utilities using cross-compatible path detection
source "$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)/teardown_utils.sh"

# Provide guidance for font removal
provide_font_cleanup_guidance() {
    print_status "Font cleanup guidance:"
    print_warning "Fonts cannot be safely auto-removed as they might be used by other applications"
    print_status "If you want to remove the Nerd Fonts installed by Shell-Pro:"
    
    echo ""
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command_exists brew; then
            print_status "On macOS with Homebrew, you can remove Meslo Nerd Font:"
            echo "   brew uninstall --cask font-meslo-lg-nerd-font"
            echo ""
            print_status "To see all installed font casks:"
            echo "   brew list --cask | grep font"
        else
            print_status "On macOS without Homebrew:"
            echo "   - Open Font Book application"
            echo "   - Search for 'Meslo' or 'Nerd Font'"
            echo "   - Select the fonts and click 'Remove'"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        print_status "On Linux, fonts may have been installed via package manager:"
        
        if command_exists apt; then
            echo "   sudo apt remove fonts-powerline"
        elif command_exists yum; then
            echo "   sudo yum remove powerline-fonts"
        elif command_exists dnf; then
            echo "   sudo dnf remove powerline-fonts"
        elif command_exists pacman; then
            echo "   sudo pacman -R powerline-fonts"
        fi
        
        echo ""
        print_status "You can also manually remove fonts from:"
        echo "   ~/.local/share/fonts/ (user fonts)"
        echo "   /usr/share/fonts/ (system fonts)"
        echo ""
        print_status "After removing fonts, update font cache:"
        echo "   fc-cache -fv"
    else
        print_status "For your OS type ($(echo "$OSTYPE")), please manually remove fonts"
        print_status "Look for 'Meslo' or 'Nerd Font' in your system's font management tool"
    fi
    
    echo ""
    print_warning "⚠️  Only remove fonts if you're sure no other applications need them!"
}

# Check if fonts are still needed
check_font_usage() {
    print_status "Checking if Nerd Fonts might still be needed..."
    
    # Check for other terminal configurations that might use Nerd Fonts
    local configs_to_check=(
        "$HOME/.config/alacritty/alacritty.yml"
        "$HOME/.config/kitty/kitty.conf"
        "$HOME/.config/wezterm/wezterm.lua"
        "$HOME/.tmux.conf"
        "$HOME/.config/starship.toml"
    )
    
    local found_usage=false
    for config in "${configs_to_check[@]}"; do
        if [ -f "$config" ] && grep -qi "meslo\|nerd.*font\|powerline" "$config" 2>/dev/null; then
            print_warning "Found potential Nerd Font usage in: $config"
            found_usage=true
        fi
    done
    
    if [ "$found_usage" = true ]; then
        print_warning "Other applications may be using Nerd Fonts. Consider keeping them installed."
    else
        print_status "No other Nerd Font usage detected in common configuration files"
    fi
}