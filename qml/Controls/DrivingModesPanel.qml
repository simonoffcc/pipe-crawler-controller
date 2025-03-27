import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import WheelController 1.0

ColumnLayout {
    id: root
    
    Text {
        id: controlsTitle
        
        Layout.leftMargin: 10
        Layout.topMargin: 10
        Layout.rightMargin: 10
        
        font.pixelSize: 16
        color: "black"
        text: qsTr("Pair Grouping/Drive modes")
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
        textRole: "title"
        valueRole: "modeId"
        model: [
            { modeId: 0, title: qsTr("Custom") },
            { modeId: 1, title: qsTr("Left-Right wheel pairs") },
            { modeId: 2, title: qsTr("All cross pairs") }
        ]

        onActivated: {
            WheelController.setPairsGroupingMode(modeId)
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
        textRole: "title"
        valueRole: "modeId"
        model: [
            { modeId: 0, title: qsTr("Custom") },
            { modeId: 1, title: qsTr("Front-drive") },
            { modeId: 2, title: qsTr("Rear-drive") },
            { modeId: 3, title: qsTr("Full-drive") }
        ]
    }
}
