import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import WheelController
import pairsGroupingMode
import driveMode

ColumnLayout {
    id: root
    
    readonly property bool isCustomMode: pairGroupingModes.currentValue === PairsGroupingMode.Custom &&
                                      driveModes.currentValue === DriveMode.Custom
    
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
            if (currentValue === PairsGroupingMode.Custom) {
                // Если выбран Custom, то и второй комбобокс должен стать Custom
                driveModes.currentIndex = 0;
                WheelController.setDriveMode(DriveMode.Custom);
            } else if (driveModes.currentValue === DriveMode.Custom) {
                // Если был Custom в другом комбобоксе, устанавливаем значения по умолчанию
                driveModes.currentIndex = 3; // Full-drive
                WheelController.setDriveMode(DriveMode.AllWheelDrive);
            }
            WheelController.setPairsGroupingMode(currentValue);
        }
    }
    
    ComboBox {
        id: driveModes
        
        Layout.leftMargin: 15
        Layout.topMargin: 5
        Layout.rightMargin: 10
        Layout.preferredWidth: 200
        
        implicitContentWidthPolicy: ComboBox.WidestText
        currentIndex: 3  // Full-drive по умолчанию
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
                // Если выбран Custom, то и второй комбобокс должен стать Custom
                pairGroupingModes.currentIndex = 0;
                WheelController.setPairsGroupingMode(PairsGroupingMode.Custom);
            } else if (pairGroupingModes.currentValue === PairsGroupingMode.Custom) {
                // Если был Custom в другом комбобоксе, устанавливаем значения по умолчанию
                pairGroupingModes.currentIndex = 1; // All cross pairs
                WheelController.setPairsGroupingMode(PairsGroupingMode.AllPairs);
            }
            WheelController.setDriveMode(currentValue);
        }
    }

}
