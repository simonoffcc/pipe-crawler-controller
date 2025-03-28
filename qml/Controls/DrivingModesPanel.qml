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
            { value: PairsGroupingMode.CUSTOM, text: qsTr("Custom") },
            { value: PairsGroupingMode.LEFT_RIGHT, text: qsTr("Left-Right wheel pairs") },
            { value: PairsGroupingMode.ALL_PAIRS, text: qsTr("All cross pairs") }
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
            { value: DriveMode.CUSTOM, text: qsTr("Custom") },
            { value: DriveMode.FRONT_DRIVE, text: qsTr("Front-drive") },
            { value: DriveMode.REAR_DRIVE, text: qsTr("Rear-drive") },
            { value: DriveMode.ALL_WHEEL_DRIVE, text: qsTr("Full-drive") }
        ]

        onActivated: {
            WheelController.setDriveMode(currentValue)
        }
    }
}
