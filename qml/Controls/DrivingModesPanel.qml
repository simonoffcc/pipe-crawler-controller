import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import WheelController
import PairsGroupingMode
import DriveMode

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
            { value: PairsGroupingMode.Mode.Custom, text: qsTr("Custom") },
            { value: PairsGroupingMode.Mode.LeftRight, text: qsTr("Left-Right wheel pairs") },
            { value: PairsGroupingMode.Mode.AllPairs, text: qsTr("All cross pairs") }
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
            { value: DriveMode.Mode.Custom, text: qsTr("Custom") },
            { value: DriveMode.Mode.FrontDrive, text: qsTr("Front-drive") },
            { value: DriveMode.Mode.RearDrive, text: qsTr("Rear-drive") },
            { value: DriveMode.Mode.AllWheelDrive, text: qsTr("Full-drive") }
        ]

        onActivated: {
            WheelController.setDriveMode(currentValue)
        }
    }
}
