import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import RobotController
import pairsGroupingMode
import driveMode

Rectangle {
    id: root
    color: "lightgray"
    implicitHeight: contentLayout.implicitHeight + contentLayout.spacing + contentLayout.anchors.bottomMargin

    readonly property bool isCustomMode: RobotController.currentPairsGroupingMode === PairsGroupingMode.Custom &&
                                      RobotController.currentDriveMode === DriveMode.Custom

    property bool isLocked: false

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        Text {
            id: title
            Layout.fillWidth: true
            font.pixelSize: 14
            font.bold: true
            color: "black"
            text: qsTr("Pair Grouping/Driving modes")
        }

        ComboBox {
            id: pairsGroupingMode
            Layout.fillWidth: true
            Layout.preferredHeight: 32

            implicitContentWidthPolicy: ComboBox.WidestText
            currentIndex: RobotController.currentPairsGroupingMode
            displayText: "Grouping: " + currentText
            textRole: "text"
            valueRole: "value"
            model: [
                { value: PairsGroupingMode.Custom, text: qsTr("Custom") },
                { value: PairsGroupingMode.LeftRightPairs, text: qsTr("Left-Right wheel pairs") },
                { value: PairsGroupingMode.AllPairs, text: qsTr("All cross pairs") }
            ]

            onActivated: {
                if (currentValue === PairsGroupingMode.Custom) {
                    driveMode.currentIndex = findIndexByValue(driveMode, DriveMode.Custom);
                    RobotController.setDriveMode(DriveMode.Custom);
                }
                else if (driveMode.currentValue === DriveMode.Custom) {
                    driveMode.currentIndex = findIndexByValue(driveMode, DriveMode.FullDrive);
                    RobotController.setDriveMode(DriveMode.FullDrive);
                }
                RobotController.setPairsGroupingMode(currentValue);
            }
        }

        ComboBox {
            id: driveMode
            Layout.fillWidth: true
            Layout.preferredHeight: 32

            implicitContentWidthPolicy: ComboBox.WidestText
            currentIndex: findIndexByValue(driveMode, RobotController.currentDriveMode)
            displayText: "Drive mode: " + currentText
            textRole: "text"
            valueRole: "value"
            model: [
                { value: DriveMode.Custom, text: qsTr("Custom") },
                { value: DriveMode.FrontDrive, text: qsTr("Front-drive") },
                { value: DriveMode.RearDrive, text: qsTr("Rear-drive") },
                { value: DriveMode.FullDrive, text: qsTr("Full-drive") }
            ]

            onActivated: {
                if (currentValue === DriveMode.Custom) {
                    pairsGroupingMode.currentIndex = findIndexByValue(pairsGroupingMode, PairsGroupingMode.Custom);
                    RobotController.setPairsGroupingMode(PairsGroupingMode.Custom);
                }
                else if (pairsGroupingMode.currentValue === PairsGroupingMode.Custom) {
                    pairsGroupingMode.currentIndex = findIndexByValue(pairsGroupingMode, PairsGroupingMode.AllPairs);
                    RobotController.setPairsGroupingMode(PairsGroupingMode.AllPairs);
                }
                RobotController.setDriveMode(currentValue);
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

    function findIndexByValue(comboBox, value) {
        for (let i = 0; i < comboBox.model.length; i++) {
            if (comboBox.model[i].value === value) {
                return i;
            }
        }
        return 0;
    }

}
