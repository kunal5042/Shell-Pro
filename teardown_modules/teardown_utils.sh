#!/bin/bash

# Shell-Pro Teardown Utils Module
# Common utilities for teardown operations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions for consistent output formatting
print_status() {
    echo -e "${BLUE}[TEARDOWN INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[TEARDOWN SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[TEARDOWN WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[TEARDOWN ERROR]${NC} $1"
}

# Function to get the Shell-Pro directory path
get_shell_pro_dir() {
    echo "$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a file or directory exists
path_exists() {
    [ -e "$1" ]
}

# Function to safely remove file/directory with confirmation
safe_remove() {
    local path="$1"
    local description="$2"
    
    if path_exists "$path"; then
        print_status "Removing $description: $path"
        if rm -rf "$path" 2>/dev/null; then
            print_success "Successfully removed $description"
            return 0
        else
            print_error "Failed to remove $description: $path"
            return 1
        fi
    else
        print_status "$description not found, skipping: $path"
        return 0
    fi
}

# Function to ask for user confirmation
confirm_action() {
    local message="$1"
    echo -e "${YELLOW}⚠️  $message${NC}"
    echo -n "Do you want to proceed? (y/N): "
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}