#!/bin/bash

echo "Uninstalling Command Plasma Widget..."

# Get the widget ID from metadata.json
WIDGET_ID=$(grep -oP '"Id":\s*"\K[^"]+' metadata.json)

if [ -z "$WIDGET_ID" ]; then
    echo "Error: Could not determine widget ID from metadata.json!"
    exit 1
fi

echo "Detected Widget ID: $WIDGET_ID"

# Check if kpackagetool6 exists
if command -v kpackagetool6 &> /dev/null; then
    KPACKAGE_TOOL=kpackagetool6
# Check if kpackagetool5 exists (it's also compatible with Plasma 6)
elif command -v kpackagetool5 &> /dev/null; then
    KPACKAGE_TOOL=kpackagetool5
else
    echo "Error: kpackagetool6 or kpackagetool5 not found!"
    echo "Please install plasma-framework or plasma6-framework package."
    exit 1
fi

# Uninstall the widget
echo "Removing widget..."
$KPACKAGE_TOOL -t Plasma/Applet -r $WIDGET_ID

if [ $? -eq 0 ]; then
    echo "Widget uninstalled successfully."
    
    # Ask to restart Plasma
    read -p "Do you want to restart Plasma to apply changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Restarting Plasma..."
        if command -v kquitapp6 &> /dev/null; then
            kquitapp6 plasmashell && plasmashell &
        else
            kquitapp5 plasmashell && plasmashell &
        fi
        echo "Plasma restarted."
    fi
else
    echo "Error uninstalling widget. Check the output above for details."
    exit 1
fi

echo "Done!" 