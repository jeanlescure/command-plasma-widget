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

<!--
### From Release Package

1. Download the latest `.plasmoid` file from the releases page
2. Install using KPackageTool:
```
kpackagetool6 -t Plasma/Applet -i command-plasma-1.0.plasmoid
```
-->

## Usage

1. Right-click on your KDE Plasma panel and select "Add Widgets"
2. Search for "Command Plasma" and add it to your panel
3. Right-click on the widget and select "Configure Command Plasma"
4. Enter the CLI command you want to run
5. Choose an icon (either a system icon name or a full path to an image file)
6. Adjust refresh interval if you want the command to auto-update
7. Click "OK" to save the configuration

You can add multiple instances of the widget to your panel, each with its own command and icon.

## HTML Output Formatting

The widget supports basic HTML formatting in command output. You can make your command print HTML to enhance the display:

- **Bold text**: `<b>bold text</b>`
- **Colored text**: `<span style="color: #FF5733;">colored text</span>`
- **Underlined text**: `<u>underlined text</u>`
- **Combinations**: `<b><span style="color: #33FF57;">bold green text</span></b>`

## Configuration Options

- **Command**: The CLI command to execute
- **Icon**: Icon name or path to an image file
- **Refresh interval**: Time in seconds between automatic command executions (0 to disable)
- **Run on startup**: Whether to execute the command when the widget loads

## Contributing

Contributions are welcome! Please feel free to submit pull requests or report issues.

## License

This project is licensed under the terms of the Apache License v2.0
