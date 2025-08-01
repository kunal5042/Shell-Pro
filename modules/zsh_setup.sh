#!/bin/bash

# Shell-Pro ZSH Setup Module
# Handles ZSH installation and shell switching

# Source utilities
source "$(dirname "$0")/utils.sh"

# Check if zsh is installed and install if needed
check_and_install_zsh() {
    if ! command_exists zsh; then
        print_warning "zsh is not installed. Installing zsh..."
        
        if is_macos; then
            # macOS
            if command_exists brew; then
                brew install zsh
                print_success "zsh installed via Homebrew"
            else
                print_error "Homebrew not found. Please install Homebrew first or install zsh manually"
                exit 1
            fi
        elif is_linux; then
            # Linux
            if command_exists apt; then
                # Debian/Ubuntu
                sudo apt update && sudo apt install -y zsh
                print_success "zsh installed via apt"
            elif command_exists yum; then
                # RHEL/CentOS/Fedora (older)
                sudo yum install -y zsh
                print_success "zsh installed via yum"
            elif command_exists dnf; then
                # Fedora (newer)
                sudo dnf install -y zsh
                print_success "zsh installed via dnf"
            elif command_exists pacman; then
                # Arch Linux
                sudo pacman -S --noconfirm zsh
                print_success "zsh installed via pacman"
            else
                print_error "No supported package manager found. Please install zsh manually"
                exit 1
            fi
        else
            print_error "Unknown OS type: $(get_os_type). Please install zsh manually"
            exit 1
        fi
    else
        print_success "zsh is already installed"
    fi
}

# Check current shell and restart in zsh if needed
check_and_switch_to_zsh() {
    # Check if we're running in bash and zsh is available
    if [ -n "$BASH_VERSION" ] && command_exists zsh; then
        print_status "Script was run from bash. Switching to zsh..."
        export SHELL="$(which zsh)"
        exec zsh "$0" "$@"
    elif [ -z "$ZSH_VERSION" ] && [ -z "$BASH_VERSION" ]; then
        print_warning "Running in unknown shell. Attempting to switch to zsh..."
        if command_exists zsh; then
            export SHELL="$(which zsh)"
            exec zsh "$0" "$@"
        fi
    fi
}

# Set zsh as default shell if not already
setup_default_shell() {
    local ZSH_PATH="$(which zsh)"
    local CURRENT_DEFAULT_SHELL="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)"
    
    if [ -z "$CURRENT_DEFAULT_SHELL" ]; then
        # Fallback for systems without getent (like macOS)
        CURRENT_DEFAULT_SHELL="$SHELL"
    fi

    if [ "$CURRENT_DEFAULT_SHELL" != "$ZSH_PATH" ]; then
        print_status "Setting zsh as default shell..."
        if command_exists chsh; then
            if chsh -s "$ZSH_PATH" 2>/dev/null; then
                print_success "Default shell changed to zsh (restart terminal to take effect)"
            else
                print_warning "Failed to change default shell. You may need to:"
                print_warning "1. Add zsh to /etc/shells: echo '$ZSH_PATH' | sudo tee -a /etc/shells"
                print_warning "2. Then run: chsh -s '$ZSH_PATH'"
            fi
        else
            print_warning "Could not change default shell automatically. Please run: chsh -s $ZSH_PATH"
        fi
    else
        print_success "zsh is already the default shell"
    fi
}