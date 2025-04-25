import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import rayName

Row {
    id: root

    spacing: 5

    property int rayName: RayName.Unknown
    property int backgroundWidth: 100
    property int commonHeight: 25
    property int commonRadidus: 4
    property alias currentSpinBoxValue: spinBox.value

    signal spinBoxValueChanged(real value)
    signal publishButtonClicked()

    SpinBox {
        id: spinBox

        from: 0
        to: 220
        stepSize: 1
        editable: true

        leftPadding: down.indicator ? down.indicator.width : 0
        rightPadding: up.indicator ? up.indicator.width : 0

        onValueModified: {
            root.spinBoxValueChanged(value)
        }

        contentItem: Item {
            implicitWidth: input.implicitWidth
            implicitHeight: input.implicitHeight

            TextInput {
                id: input
                anchors.fill: parent

                text: spinBox.textFromValue(spinBox.value, spinBox.locale)
                font: spinBox.font
                color: "black"
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter

                readOnly: !spinBox.editable
                validator: spinBox.validator
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                onTextEdited: {
                    spinBox.value = parseInt(text, 10)
                    root.spinBoxValueChanged(spinBox.value)
                }
            }
        }

        up.indicator: Item {
            x: spinBox.mirrored ? 0 : parent.width - width
            height: parent.height
            implicitWidth: 30
            implicitHeight: root.commonHeight

            Rectangle {
                anchors.fill: parent
                color: spinBox.up.pressed ? "#e4e4e4" : "#f6f6f6"
                border.color: enabled ? "#97999b" : "#bdbebf"
                radius: root.commonRadidus

                Text {
                    anchors.centerIn: parent
                    text: "+1"
                    font.pixelSize: spinBox.font.pixelSize
                    color: "#97999b"
                }
            }
        }

        down.indicator: Item {
            x: spinBox.mirrored ? parent.width - width : 0
            height: parent.height
            implicitWidth: 30
            implicitHeight: root.commonHeight

            Rectangle {
                anchors.fill: parent
                color: spinBox.down.pressed ? "#e4e4e4" : "#f6f6f6"
                border.color: enabled ? "#97999b" : "#bdbebf"
                radius: root.commonRadidus

                Text {
                    anchors.centerIn: parent
                    text: "-1"
                    font.pixelSize: spinBox.font.pixelSize
                    color: "#97999b"
                }
            }
        }

        background: Rectangle {
            id: spinBoxBackground

            implicitWidth: backgroundWidth
            border.color: "#bdbebf"
            radius: root.commonRadidus
        }
    }

    Button {
        id: publishButton

        implicitWidth: 60
        implicitHeight: root.commonHeight
        hoverEnabled: true

        text: qsTr("Publish")

        background: Rectangle {
            property color normalColor: "#ffffff"
            property color hoveredColor: "#cccccc"
            property color pressedColor: "#999999"

            radius: root.commonRadidus
            color: publishButton.pressed ? pressedColor :
                   publishButton.hovered ? hoveredColor : normalColor

            border.color: enabled ? "#97999b" : "#bdbebf"
        }

        contentItem: Text {
            anchors.fill: parent

            text: publishButton.text
            font.pixelSize: 12
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        onClicked: {
            root.publishButtonClicked();
        }
    }
}
