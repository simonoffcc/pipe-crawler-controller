import QtQuick
import QtQuick.Controls.Basic

SpinBox {
    id: control

    from: 0
    to: 220
    value: from
    editable: true

    padding: 0
    leftPadding: down.indicator ? down.indicator.width + commonSpacing : commonSpacing
    rightPadding: up.indicator ? up.indicator.width + commonSpacing : commonSpacing

    property int commonSpacing: 4

    font.pixelSize: 12

    contentItem: Item {
        implicitWidth: input.implicitWidth
        implicitHeight: input.implicitHeight

        TextInput {
            id: input
            anchors.fill: parent
            text: control.textFromValue(control.value, control.locale)

            font: control.font
            color: "black"
            selectionColor: "#97999b"
            selectedTextColor: "#ffffff"
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter

            readOnly: !control.editable
            validator: control.validator
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }
    }

    up.indicator: Item {
        x: control.mirrored ? commonSpacing : parent.width - width - commonSpacing
        height: parent.height
        implicitWidth: 32
        implicitHeight: 32
        
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            color: control.up.pressed ? "#e4e4e4" : "#f6f6f6"
            border.color: enabled ? "#97999b" : "#bdbebf"
            radius: 4

            Text {
                anchors.centerIn: parent
                text: "+1"
                font.pixelSize: control.font.pixelSize * 1.5
                color: "#97999b"
            }
        }
    }

    down.indicator: Item {
        x: control.mirrored ? parent.width - width - commonSpacing : commonSpacing
        height: parent.height
        implicitWidth: 32
        implicitHeight: 32

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            color: control.down.pressed ? "#e4e4e4" : "#f6f6f6"
            border.color: enabled ? "#97999b" : "#bdbebf"
            radius: 4

            Text {
                anchors.centerIn: parent
                text: "-1"
                font.pixelSize: control.font.pixelSize * 1.5
                color: "#97999b"
            }
        }
    }

    background: Rectangle {
        implicitWidth: 120
        border.color: "#bdbebf"
        radius: 4
    }
}
