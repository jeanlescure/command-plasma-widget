#!/bin/bash

# Extract version from metadata.json
VERSION=$(grep -oP '"Version":\s*"\K[^"]+' metadata.json)
NAME=$(grep -oP '"Id":\s*"\K[^"]+' metadata.json)

# Sanitize NAME to get just the last part after the last dot
SIMPLE_NAME=$(echo $NAME | sed -e 's/.*\.//')

# Create the package file name
PACKAGE_NAME="${SIMPLE_NAME}-${VERSION}.plasmoid"

echo "Creating package $PACKAGE_NAME..."

# Clean any existing package with the same name
rm -f "$PACKAGE_NAME"

# Create the zip archive
zip -r "$PACKAGE_NAME" * -x ".git*" -x "*.sh" -x "README.md" -x ".github*"

echo "Package created: $PACKAGE_NAME"
echo ""
echo "You can install it using:"
echo "kpackagetool6 -t Plasma/Applet -i $PACKAGE_NAME" 