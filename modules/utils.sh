#!/bin/bash

# Shell-Pro Utils Module
# Common utilities and helper functions

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions for consistent output formatting
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Cross-compatible function to get the directory of any script
get_script_dir() {
    local script_path="${1:-${BASH_SOURCE[1]:-${(%):-%x}}}"
    echo "$(cd "$(dirname "$script_path")" && pwd)"
}

# Function to get the Shell-Pro directory path
get_shell_pro_dir() {
    local source_file
    if [ -n "${BASH_SOURCE[1]}" ]; then
        # Running in bash
        source_file="${BASH_SOURCE[1]}"
    elif [ -n "${(%):-%x}" ]; then
        # Running in zsh
        source_file="${(%):-%x}"
    else
        # Fallback
        source_file="$0"
    fi
    echo "$(cd "$(dirname "$source_file")" && pwd)"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS type
get_os_type() {
    echo "$OSTYPE"
}

# Function to check if running on macOS
is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

# Function to check if running on Linux
is_linux() {
    [[ "$OSTYPE" == "linux-gnu"* ]]
}