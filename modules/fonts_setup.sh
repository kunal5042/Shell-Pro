#!/bin/bash

# Shell-Pro Fonts Setup Module
# Handles Nerd Fonts installation (platform-specific)

# Source utilities
source "$(dirname "$0")/utils.sh"

# Install Nerd Fonts for Powerlevel10k
install_nerd_fonts() {
    print_status "Checking for Nerd Fonts (required for Powerlevel10k)..."

    if is_macos; then
        # macOS
        if command_exists brew; then
            print_status "Installing Nerd Fonts via Homebrew..."
            brew tap homebrew/cask-fonts 2>/dev/null || true
            brew install --cask font-meslo-lg-nerd-font 2>/dev/null || print_warning "Font installation failed or already installed"
        else
            print_warning "Homebrew not found. Please install Nerd Fonts manually:"
            print_warning "Visit: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"
        fi
    elif is_linux; then
        # Linux
        print_status "Attempting to install Nerd Fonts on Linux..."
        
        # Try different package managers
        if command_exists apt; then
            # Debian/Ubuntu
            sudo apt update && sudo apt install -y fonts-powerline 2>/dev/null || print_warning "Font installation via apt failed"
        elif command_exists yum; then
            # RHEL/CentOS/Fedora (older)
            sudo yum install -y powerline-fonts 2>/dev/null || print_warning "Font installation via yum failed"
        elif command_exists dnf; then
            # Fedora (newer)
            sudo dnf install -y powerline-fonts 2>/dev/null || print_warning "Font installation via dnf failed"
        elif command_exists pacman; then
            # Arch Linux
            sudo pacman -S --noconfirm powerline-fonts 2>/dev/null || print_warning "Font installation via pacman failed"
        else
            print_warning "No supported package manager found for automatic font installation"
        fi
        
        print_warning "For best results, manually install Meslo Nerd Font:"
        print_warning "Visit: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"
    else
        print_warning "Unknown OS type: $(get_os_type)"
        print_warning "Please install Nerd Fonts manually:"
        print_warning "Visit: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"
    fi
}