import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

Item {
    id: generalPage
    width: childrenRect.width
    height: childrenRect.height
    
    property string title: i18n("General")
    
    property alias cfg_command: commandField.text
    property alias cfg_icon: iconField.text
    property alias cfg_refreshInterval: refreshIntervalSpinBox.value
    property alias cfg_runOnStartup: runOnStartupCheckBox.checked

    Kirigami.FormLayout {
        id: generalForm
        anchors.left: parent.left
        anchors.right: parent.right
        
        RowLayout {
            Kirigami.FormData.label: i18n("Command:")
            
            TextField {
                id: commandField
                placeholderText: i18n("Enter CLI command")
                Layout.fillWidth: true
            }
            
            Button {
                id: testCommandButton
                icon.name: "media-playback-start"
                text: i18n("Test")
                ToolTip.text: i18n("Run the command to test it")
                
                // Function to run the test
                function runTest() {
                    var process = Qt.createQmlObject('
                        import QtQuick
                        import org.kde.plasma.plasma5support as Plasma5Support
                        
                        Plasma5Support.DataSource {
                            id: executableNotifier
                            engine: "executable"
                            connectedSources: []
                            
                            onNewData: function(sourceName, data) {
                                var exitCode = data["exit code"]
                                var exitStatus = data["exit status"]
                                var stdout = data["stdout"]
                                var stderr = data["stderr"]
                                
                                if (exitCode === 0) {
                                    testOutput.text = stdout
                                } else {
                                    testOutput.text = "Error: " + stderr
                                }
                                
                                disconnectSource(sourceName)
                                destroy()
                            }
                            
                            function run(cmd) {
                                connectSource(cmd)
                            }
                        }
                    ', testCommandButton, 'testProcess')
                    
                    process.run(commandField.text)
                }
                
                onClicked: runTest()
            }
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Icon:")
            
            TextField {
                id: iconField
                placeholderText: i18n("Icon name or full path")
                Layout.fillWidth: true
            }
            
            Button {
                id: iconButton
                icon.name: "document-open"
                text: i18n("Browse...")
                ToolTip.text: i18n("Choose an icon")
                
                onClicked: {
                    iconDialog.open()
                }
            }
            
            Rectangle {
                width: Kirigami.Units.iconSizes.medium
                height: Kirigami.Units.iconSizes.medium
                color: "transparent"
                
                Kirigami.Icon {
                    anchors.fill: parent
                    source: iconField.text || "utilities-terminal"
                }
            }
        }

        SpinBox {
            id: refreshIntervalSpinBox
            Kirigami.FormData.label: i18n("Refresh interval (seconds):")
            from: 0
            to: 3600
            stepSize: 1
            editable: true
            
            ToolTip.text: i18n("Set to 0 to disable auto-refresh")
            ToolTip.visible: hovered
        }

        CheckBox {
            id: runOnStartupCheckBox
            Kirigami.FormData.label: i18n("Run on startup:")
            text: i18n("Execute command when widget loads")
        }
        
        Item {
            Kirigami.FormData.isSection: true
        }
        
        Label {
            text: i18n("Test Output:")
            font.bold: true
        }
        
        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 5
            
            TextArea {
                id: testOutput
                readOnly: true
                font.family: "Monospace"
                wrapMode: TextEdit.NoWrap
                placeholderText: i18n("Command output will appear here after testing")
            }
        }
    }
    
    FileDialog {
        id: iconDialog
        title: i18n("Please choose an icon")
        nameFilters: [ "Image files (*.png *.jpg *.svg)", "All files (*)" ]
        fileMode: FileDialog.OpenFile
        
        onAccepted: {
            // Convert the URL to a local file path
            iconField.text = iconDialog.selectedFile.toString().replace("file://", "")
        }
    }
} 