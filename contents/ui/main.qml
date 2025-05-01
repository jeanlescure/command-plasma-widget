import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as P5Support
import "TextProcessing.js" as TextProcessing

PlasmoidItem {
    id: root
    
    // Store our configuration values with defaults
    property string command: Plasmoid.configuration.command || "echo 'Configure a command in settings'"
    property string iconPath: Plasmoid.configuration.icon || "utilities-terminal"
    property int refreshInterval: Plasmoid.configuration.refreshInterval || 0
    property bool runOnStartup: Plasmoid.configuration.runOnStartup || false
    
    // Store command output
    property string commandOutput: ""
    property bool isExecuting: false
    
    // For tooltip display
    toolTipMainText: Plasmoid.title || i18n("Command Plasma")
    toolTipSubText: command
    
    // Plasmoid sizing preferences
    preferredRepresentation: compactRepresentation
    
    // Hide popup on window deactivation
    hideOnWindowDeactivate: true
    
    // Listen for activation and configuration changes
    Connections {
        target: Plasmoid
        function onActivated() {
            executeCommand();
        }
        
        function onConfigurationChanged() {
            command = Plasmoid.configuration.command || "echo 'Configure a command in settings'";
            iconPath = Plasmoid.configuration.icon || "utilities-terminal";
            refreshInterval = Plasmoid.configuration.refreshInterval || 0;
            runOnStartup = Plasmoid.configuration.runOnStartup || false;
            
            // Restart timer if refresh interval changed
            if (refreshTimer.running) {
                refreshTimer.restart();
            } else if (refreshInterval > 0) {
                refreshTimer.start();
            }
            
            // Execute the command with the new configuration
            executeCommand();
        }
    }
    
    // Run command on startup if configured
    Component.onCompleted: {
        console.log("Widget initialized with command: " + command);
        console.log("Icon path: " + iconPath);
        
        if (runOnStartup) {
            executeCommand();
        }
    }
    
    // Create our data source for running commands
    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        
        onNewData: function(sourceName, data) {
            var exitCode = data["exit code"];
            var exitStatus = data["exit status"];
            var stdout = data["stdout"];
            var stderr = data["stderr"];
            
            console.log("Command executed with exit code: " + exitCode);
            
            if (exitCode === 0) {
                commandOutput = stdout;
                console.log("Command output: " + stdout.substring(0, 100) + (stdout.length > 100 ? "..." : ""));
            } else {
                commandOutput = "Error: " + stderr;
                console.log("Command error: " + stderr);
            }
            
            disconnectSource(sourceName);
            isExecuting = false;
        }
        
        function exec(cmd) {
            if (!isExecuting) {
                console.log("Executing command: " + cmd);
                isExecuting = true;
                connectSource(cmd);
            }
        }
    }
    
    // Timer for auto-refresh
    Timer {
        id: refreshTimer
        interval: refreshInterval * 1000
        running: refreshInterval > 0
        repeat: true
        onTriggered: executeCommand()
    }
    
    function executeCommand() {
        if (command && command.trim() !== "") {
            executable.exec(command);
        } else {
            commandOutput = i18n("No command configured. Right-click to configure.");
            isExecuting = false;
        }
    }
    
    function toggleExpanded() {
        root.expanded = !root.expanded;
    }
    
    // Content that appears on the panel
    compactRepresentation: Loader {
        id: compactLoader
        source: "CompactRepresentation.qml"
        
        onLoaded: {
            item.iconSource = root.iconPath;
            item.isExecuting = root.isExecuting;
        }
        
        Connections {
            target: root
            function onIconPathChanged() {
                if (compactLoader.item) {
                    compactLoader.item.iconSource = root.iconPath;
                }
            }
            function onIsExecutingChanged() {
                if (compactLoader.item) {
                    compactLoader.item.isExecuting = root.isExecuting;
                }
            }
        }
        
        Connections {
            target: compactLoader.item
            function onExecuteCommand() { root.executeCommand() }
            function onToggleExpanded() { root.toggleExpanded() }
        }
    }
    
    // Popup content that appears when clicked
    fullRepresentation: Loader {
        id: fullLoader
        source: "FullRepresentation.qml"
        
        onLoaded: {
            item.commandOutput = root.commandOutput;
            item.isExecuting = root.isExecuting;
        }
        
        Connections {
            target: root
            function onCommandOutputChanged() {
                if (fullLoader.item) {
                    fullLoader.item.commandOutput = root.commandOutput;
                }
            }
            function onIsExecutingChanged() {
                if (fullLoader.item) {
                    fullLoader.item.isExecuting = root.isExecuting;
                }
            }
        }
        
        Connections {
            target: fullLoader.item
            function onExecuteCommand() { root.executeCommand() }
        }
    }
}
