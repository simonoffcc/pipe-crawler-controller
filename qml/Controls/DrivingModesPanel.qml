import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import WheelController
import pairsGroupingMode
import driveMode

ColumnLayout {
    id: root
    
    Text {
        id: controlsTitle
        
        Layout.leftMargin: 10
        Layout.topMargin: 10
        Layout.rightMargin: 10
        
        font.pixelSize: 16
        color: "black"
        text: qsTr("Pair Grouping/Driving modes")
    }
    
    ComboBox {
        id: pairGroupingModes
        
        Layout.leftMargin: 15
        Layout.topMargin: 5
        Layout.rightMargin: 10
        Layout.preferredWidth: 200
        
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
            WheelController.setPairsGroupingMode(currentValue)
        }
    }
    
    ComboBox {
        id: driveModes
        
        Layout.leftMargin: 15
        Layout.topMargin: 5
        Layout.rightMargin: 10
        Layout.preferredWidth: 200
        
        implicitContentWidthPolicy: ComboBox.WidestText
        currentIndex: 1
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
            WheelController.setDriveMode(currentValue)
        }
    }
}
