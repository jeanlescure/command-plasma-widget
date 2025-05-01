import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "TextProcessing.js" as TextProcessing

Item {
    id: fullRoot
    
    // Access parent root properties
    property string commandOutput: ""
    property bool isExecuting: false
    
    // Signal to execute command
    signal executeCommand()
    
    // Processed command output
    property string processedOutput: TextProcessing.cleanOutput(commandOutput)
    
    // Font size for the output
    property int fontSize: Kirigami.Theme.defaultFont.pointSize
    
    // Calculate dimensions based on the text content
    property var textDimensions: TextProcessing.getTextDimensions(processedOutput, "Monospace", fontSize)
    
    // Layout properties - let Plasma handle the sizing
    Layout.minimumWidth: Math.min(textDimensions.width + Kirigami.Units.gridUnit * 2, Kirigami.Units.gridUnit * 30)
    Layout.preferredWidth: Math.min(textDimensions.width + Kirigami.Units.gridUnit * 2, Kirigami.Units.gridUnit * 30)
    Layout.maximumWidth: Kirigami.Units.gridUnit * 40
    
    Layout.minimumHeight: Math.min(textDimensions.height + Kirigami.Units.gridUnit * 2, Kirigami.Units.gridUnit * 20)
    Layout.preferredHeight: Math.min(textDimensions.height + Kirigami.Units.gridUnit * 2, Kirigami.Units.gridUnit * 20)
    Layout.maximumHeight: Kirigami.Units.gridUnit * 30
    
    Component.onCompleted: {
        console.log("FullRepresentation created with output length: " + commandOutput.length);
    }
    
    // Manual watcher for command output changes
    onCommandOutputChanged: {
        console.log("Command output changed, length: " + commandOutput.length);
        processedOutput = TextProcessing.cleanOutput(commandOutput);
    }
    
    // Background for the popup
    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.backgroundColor
        opacity: 0.95
        radius: Kirigami.Units.smallSpacing
        
        // Add a subtle border
        border.width: 1
        border.color: Kirigami.Theme.disabledTextColor
    }
    
    // Loading indicator
    PlasmaComponents.BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: isExecuting
        visible: isExecuting
    }
    
    // Command output display
    ScrollView {
        id: outputScrollView
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
        
        // Only visible when not loading
        visible: !isExecuting
        
        TextArea {
            id: outputText
            text: processedOutput || ""
            readOnly: true
            font.family: "Monospace"
            font.pointSize: fontSize
            color: Kirigami.Theme.textColor
            
            // Use word wrap only for compact outputs 
            wrapMode: TextProcessing.isCompactOutput(processedOutput) ? TextEdit.Wrap : TextEdit.NoWrap
            
            background: Rectangle {
                color: "transparent"
            }
            
            // Auto scroll to top when output changes
            onTextChanged: {
                outputScrollView.contentItem.contentY = 0;
            }
        }
    }
    
    // Empty state message
    Label {
        anchors.centerIn: parent
        text: i18n("No output")
        visible: !isExecuting && (!processedOutput || processedOutput === "")
        color: Kirigami.Theme.disabledTextColor
    }
    
    // Refresh button at the top
    PlasmaComponents.ToolButton {
        id: refreshButton
        icon.name: "view-refresh"
        text: i18n("Refresh")
        display: PlasmaComponents.ToolButton.IconOnly
        
        anchors {
            top: parent.top
            right: parent.right
            margins: Kirigami.Units.smallSpacing
        }
        
        onClicked: {
            console.log("Refresh button clicked, executing command");
            executeCommand();
        }
        
        visible: !isExecuting
        
        ToolTip.text: i18n("Refresh output")
        ToolTip.visible: hovered
        ToolTip.delay: Kirigami.Units.toolTipDelay
    }
} 