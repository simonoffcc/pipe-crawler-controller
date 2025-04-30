import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
// import QtQuick.Controls.Basic

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

        CheckBox {
            id: lockCheckBox

            visible: root.isCustomMode
            Layout.alignment: Qt.AlignLeft
            text: qsTr("Prevent controller states changing")
            checked: root.isLocked

            ToolTip.visible: lockCheckBox.hovered
            ToolTip.text: lockCheckBox.checked ? qsTr("Unlock controller states") : qsTr("Lock controller states")
            ToolTip.timeout: 3000

            indicator.implicitWidth: 18
            indicator.implicitHeight: 18

            contentItem: Text {
                text: lockCheckBox.text
                font: lockCheckBox.font
                color: "black"
                verticalAlignment: Text.AlignVCenter
                leftPadding: lockCheckBox.indicator.width + lockCheckBox.spacing
            }

            onCheckedChanged: {
                root.isLocked = checked
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
