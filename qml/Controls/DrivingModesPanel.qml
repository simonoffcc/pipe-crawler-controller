import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: root
    
    Text {
        id: controlsTitle
        
        Layout.leftMargin: 10
        Layout.topMargin: 10
        Layout.rightMargin: 10
        
        font.pixelSize: 16
        color: "black"
        text: qsTr("Presets/Drive modes")
    }
    
    ComboBox {
        id: lockPresets
        
        Layout.leftMargin: 15
        Layout.topMargin: 5
        Layout.rightMargin: 10
        Layout.preferredWidth: 200
        
        implicitContentWidthPolicy: ComboBox.WidestText
        currentIndex: 1
        displayText: "Preset: " + currentText
        textRole: "title"
        valueRole: "presetId"
        model: [
            { presetId: 0, title: qsTr("Custom") },
            { presetId: 1, title: qsTr("All cross pairs") },
            { presetId: 2, title: qsTr("Left-Right wheel pairs") }
        ]
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
            { modeId: 1, title: qsTr("Full-drive") },
            { modeId: 2, title: qsTr("Front-drive") },
            { modeId: 3, title: qsTr("Rear-drive") }
        ]
    }
}
