import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

Item {
    id: compactRoot
    
    // Access the parent root properties
    property alias iconSource: icon.source
    property bool isExecuting: false
    
    // Signal to execute command
    signal executeCommand()
    
    // Signal to toggle expanded state
    signal toggleExpanded()
    
    // Sizing for the panel icon
    Layout.minimumWidth: Kirigami.Units.iconSizes.small
    Layout.preferredWidth: Kirigami.Units.iconSizes.small
    Layout.maximumWidth: Kirigami.Units.iconSizes.small
    
    Layout.minimumHeight: Kirigami.Units.iconSizes.small
    Layout.preferredHeight: Kirigami.Units.iconSizes.small
    Layout.maximumHeight: Kirigami.Units.iconSizes.small
    
    // The icon displayed in the panel
    Kirigami.Icon {
        id: icon
        anchors.fill: parent
        active: mouseArea.containsMouse
    }
    
    // Show loading indicator when executing command
    PlasmaComponents.BusyIndicator {
        anchors.fill: parent
        running: isExecuting
        visible: isExecuting
    }
    
    // Handle clicks on the icon
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        property bool wasExpanded: false
        
        onPressed: {
            // Use loader parent instead of parent.parent which might not exist
            var parentItem = compactRoot.parent;
            while (parentItem && !parentItem.hasOwnProperty("expanded")) {
                parentItem = parentItem.parent;
            }
            wasExpanded = parentItem ? parentItem.expanded : false;
        }
        
        onClicked: {
            // Execute command and toggle expanded state
            executeCommand()
            toggleExpanded()
        }
    }
} 