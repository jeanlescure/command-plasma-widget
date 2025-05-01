# Command Plasma Widget

A KDE Plasma 6 panel widget that lets you run custom CLI commands and display their output in a popup.

## Features

- Easily configure CLI commands to be run when clicking on the widget
- Customize the icon displayed in the panel for each widget instance
- View command output in a popup window that auto-sizes to fit the content
- Configure refresh intervals for automatic command execution
- Each widget instance has its own independent configuration

## Installation

### From Source

1. Clone this repository or download the ZIP file
2. Run the installation script:
```
./install.sh
```
3. Add the widget to your panel

### From Release Package

1. Download the latest `.plasmoid` file from the releases page
2. Install using KPackageTool:
```
kpackagetool6 -t Plasma/Applet -i command-plasma-1.0.plasmoid
```

## Usage

1. Right-click on your KDE Plasma panel and select "Add Widgets"
2. Search for "Command Plasma" and add it to your panel
3. Right-click on the widget and select "Configure Command Plasma"
4. Enter the CLI command you want to run
5. Choose an icon (either a system icon name or a full path to an image file)
6. Adjust refresh interval if you want the command to auto-update
7. Click "OK" to save the configuration

You can add multiple instances of the widget to your panel, each with its own command and icon.

## Example Commands

Here are some useful commands you might want to try:

- System temperature: `sensors | grep temp`
- CPU usage: `top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 + $6 + $10 + $12 + $14 + $16}' | awk '{print "CPU: " $1 "%"}'`
- Memory usage: `free -h | grep "Mem:" | awk '{print "Memory: " $3 " / " $2}'`
- Disk usage: `df -h | grep /dev/sda1 | awk '{print "Disk: " $5 " used"}'`
- IP address: `ip addr show | grep -w inet | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -d/ -f1`
- Date and time: `date "+%Y-%m-%d %H:%M:%S"`

## Configuration Options

- **Command**: The CLI command to execute
- **Icon**: Icon name or path to an image file
- **Refresh interval**: Time in seconds between automatic command executions (0 to disable)
- **Run on startup**: Whether to execute the command when the widget loads

## Contributing

Contributions are welcome! Please feel free to submit pull requests or report issues.

## License

This project is licensed under the terms of the GNU General Public License v3.0. 