import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import WheelController
import pairsGroupingMode
import driveMode

ColumnLayout {
    id: root
    
    readonly property bool isCustomMode: WheelController.currentPairsGroupingMode === PairsGroupingMode.Custom &&
                                       WheelController.currentDriveMode === DriveMode.Custom
    
    property bool isLocked: false

    Text {
        id: controlsTitle
        
        Layout.leftMargin: 10
        Layout.topMargin: 10
        Layout.rightMargin: 10
        
        font.pixelSize: 16
        color: "black"
        text: qsTr("Pair Grouping/Driving modes")
    }
    
    Row {
        Layout.leftMargin: 15
        Layout.topMargin: 5
        Layout.rightMargin: 10
        spacing: 10

        ComboBox {
            id: pairGroupingModes
            
            width: 200
            
            implicitContentWidthPolicy: ComboBox.WidestText
            displayText: "Grouping: " + currentText
            textRole: "text"
            valueRole: "value"
            model: [
                { value: PairsGroupingMode.Custom, text: qsTr("Custom") },
                { value: PairsGroupingMode.LeftRight, text: qsTr("Left-Right wheel pairs") },
                { value: PairsGroupingMode.AllPairs, text: qsTr("All cross pairs") }
            ]

            Component.onCompleted: {
                // Установка начального значения
                for (let i = 0; i < model.length; i++) {
                    if (model[i].value === WheelController.currentPairsGroupingMode) {
                        currentIndex = i;
                        break;
                    }
                }
            }

            onActivated: {
                console.log("Pair grouping mode activated with value:", currentValue);
                WheelController.setPairsGroupingMode(currentValue);
            }

            Connections {
                target: WheelController
                function onPairsGroupingModeChanged() {
                    console.log("Received pairs grouping mode changed signal, current mode:", WheelController.currentPairsGroupingMode);
                    for (let i = 0; i < pairGroupingModes.model.length; i++) {
                        if (pairGroupingModes.model[i].value === WheelController.currentPairsGroupingMode) {
                            console.log("Setting pair grouping mode index to:", i);
                            pairGroupingModes.currentIndex = i;
                            break;
                        }
                    }
                }
            }
        }

        Button {
            id: lockButton
            visible: root.isCustomMode
            width: height
            height: pairGroupingModes.height

            icon.source: root.isLocked ? "qrc:/icons/lock.png" : "qrc:/icons/unlock.png"
            icon.color: "black"

            background: Rectangle {
                radius: 5
                color: lockButton.pressed ? "#cccccc" : 
                       lockButton.hovered ? "#e6e6e6" : "white"
                border.color: "black"
                border.width: 1
            }

            ToolTip.visible: hovered
            ToolTip.text: root.isLocked ? "Unlock controller states" : "Lock controller states"

            onClicked: {
                root.isLocked = !root.isLocked
            }
        }
    }
    
    ComboBox {
        id: driveModes
        
        Layout.leftMargin: 15
        Layout.topMargin: 5
        Layout.rightMargin: 10
        Layout.preferredWidth: 200
        
        implicitContentWidthPolicy: ComboBox.WidestText
        displayText: "Drive mode: " + currentText
        textRole: "text"
        valueRole: "value"
        model: [
            { value: DriveMode.Custom, text: qsTr("Custom") },
            { value: DriveMode.FrontDrive, text: qsTr("Front-drive") },
            { value: DriveMode.RearDrive, text: qsTr("Rear-drive") },
            { value: DriveMode.AllWheelDrive, text: qsTr("Full-drive") }
        ]

        Component.onCompleted: {
            // Установка начального значения
            for (let i = 0; i < model.length; i++) {
                if (model[i].value === WheelController.currentDriveMode) {
                    currentIndex = i;
                    break;
                }
            }
        }

        onActivated: {
            console.log("Drive mode activated with value:", currentValue);
            WheelController.setDriveMode(currentValue);
        }

        Connections {
            target: WheelController
            function onDriveModeChanged() {
                console.log("Received drive mode changed signal, current mode:", WheelController.currentDriveMode);
                for (let i = 0; i < driveModes.model.length; i++) {
                    if (driveModes.model[i].value === WheelController.currentDriveMode) {
                        console.log("Setting drive mode index to:", i);
                        driveModes.currentIndex = i;
                        break;
                    }
                }
            }
        }
    }
}
