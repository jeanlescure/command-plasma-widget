#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ID=$(grep -oP '"Id":\s*"\K[^"]+' metadata.json)

echo "Running Command Plasma Widget in test mode..."
echo "Package ID: $PACKAGE_ID"
echo "Directory: $SCRIPT_DIR"
echo ""

# Try to load the package directly from the current directory
if command -v plasmoidviewer &> /dev/null; then
    echo "Using plasmoidviewer to test the widget..."
    plasmoidviewer -a "$SCRIPT_DIR"
else
    echo "Error: plasmoidviewer not found!"
    echo "Please install the plasma-sdk package to test the widget."
    echo "On most distributions you can install it with:"
    echo "  sudo apt install plasma-sdk          # For Debian/Ubuntu"
    echo "  sudo dnf install plasma-sdk          # For Fedora"
    echo "  sudo pacman -S plasma-sdk            # For Arch Linux"
    exit 1
fi 