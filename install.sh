#!/bin/bash

echo "Installing Command Plasma Widget..."

rm -rf ~/.local/share/plasma/plasmoids/com.jeanlescure.commandplasma/

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

# Try to update if already installed, otherwise install
if $KPACKAGE_TOOL -t Plasma/Applet -u .; then
    echo "Widget updated successfully."
else
    echo "First installation, installing..."
    $KPACKAGE_TOOL -t Plasma/Applet -i .
    if [ $? -eq 0 ]; then
        echo "Widget installed successfully."
    else
        echo "Error installing widget. Check the output above for details."
        exit 1
    fi
fi

# Ask to restart Plasma
read -p "Do you want to restart Plasma to load the widget? (y/n) " -n 1 -r
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

echo "Done!" 