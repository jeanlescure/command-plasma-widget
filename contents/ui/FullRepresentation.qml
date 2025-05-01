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
    
    // Set a fixed size that matches the command output
    // Use sensible defaults based on text size estimation
    Layout.minimumWidth: 400
    Layout.preferredWidth: 400
    Layout.maximumWidth: 600
    
    Layout.minimumHeight: 200
    Layout.preferredHeight: 200
    Layout.maximumHeight: 400

    // Dummy function that can be called from main.qml
    function getOutputText() {
        return outputText;
    }
    
    Component.onCompleted: {
        console.log("FullRepresentation created");
    }
    
    // Background for the popup
    Rectangle {
        id: background
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