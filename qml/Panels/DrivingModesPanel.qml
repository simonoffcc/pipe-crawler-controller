import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import WheelController
import pairsGroupingMode
import driveMode

Rectangle {
    id: root
    color: "lightgray"
    implicitHeight: contentLayout.implicitHeight + 20
    
    readonly property bool isCustomMode: WheelController.currentPairsGroupingMode === PairsGroupingMode.Custom &&
                                      WheelController.currentDriveMode === DriveMode.Custom

    property bool isLocked: false

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        Text {
            id: controlsTitle
            Layout.fillWidth: true
            font.pixelSize: 14
            font.bold: true
            color: "black"
            text: qsTr("Pair Grouping/Driving modes")
        }
        
        ComboBox {
            id: pairGroupingModes
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            
            implicitContentWidthPolicy: ComboBox.WidestText
            currentIndex: 1
            displayText: "Grouping: " + currentText
            textRole: "text"
            valueRole: "value"
            model: [
                { value: PairsGroupingMode.Custom, text: qsTr("Custom") },
                { value: PairsGroupingMode.AllPairs, text: qsTr("All cross pairs") },
                { value: PairsGroupingMode.LeftRight, text: qsTr("Left-Right wheel pairs") }
            ]

            onActivated: {
                if (currentValue === PairsGroupingMode.Custom) {
                    driveModes.currentIndex = 0;
                    WheelController.setDriveMode(DriveMode.Custom);
                }
                else if (driveModes.currentValue === DriveMode.Custom) {
                    driveModes.currentIndex = 3;
                    WheelController.setDriveMode(DriveMode.AllWheelDrive);
                }
                WheelController.setPairsGroupingMode(currentValue);
            }
        }
        
        ComboBox {
            id: driveModes
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            
            implicitContentWidthPolicy: ComboBox.WidestText
            currentIndex: 3
            displayText: "Drive mode: " + currentText
            textRole: "text"
            valueRole: "value"
            model: [
                { value: DriveMode.Custom, text: qsTr("Custom") },
                { value: DriveMode.FrontDrive, text: qsTr("Front-drive") },
                { value: DriveMode.RearDrive, text: qsTr("Rear-drive") },
                { value: DriveMode.AllWheelDrive, text: qsTr("Full-drive") }
            ]

            onActivated: {
                if (currentValue === DriveMode.Custom) {
                    pairGroupingModes.currentIndex = 0;
                    WheelController.setPairsGroupingMode(PairsGroupingMode.Custom);
                }
                else if (pairGroupingModes.currentValue === PairsGroupingMode.Custom) {
                    pairGroupingModes.currentIndex = 1;
                    WheelController.setPairsGroupingMode(PairsGroupingMode.AllPairs);
                }
                WheelController.setDriveMode(currentValue);
            }
        }

        Button {
            id: lockButton
            visible: root.isCustomMode
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignLeft

            icon.source: root.isLocked ? "/icons/lock.png" : "/icons/unlock.png"
            icon.color: "transparent"

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
}
