import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import WheelController

Rectangle {
    id: root

    width: 130
    height: 130

    radius: 15
    border.color: "gray"
    border.width: 1
    color: "#eeeeee"

    function clearSpeedInput() {
        inputField.text = "";
        inputField.focus = false;
    }

    function publishSpeed(text) {
        if (text !== "") {
            WheelController.publishGlobalSpeed(parseFloat(text))
            root.clearSpeedInput()

        }
    }

    Column {
        anchors.centerIn: parent

        width: parent.width * 0.8
        spacing: 10

        TextField {
            id: inputField

            width: parent.width
            color: "black"
            placeholderText: qsTr("dq: 1.0°/sec")
            placeholderTextColor: "gray"
            horizontalAlignment: TextInput.AlignHCenter
            font.pixelSize: 14
            bottomPadding: 5
            
            validator: DoubleValidator {
                notation: DoubleValidator.StandardNotation
                locale: "en"
            }

            background: Rectangle {
                color: "transparent"
                border.color: "black"
                border.width: 1
                height: 1
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }

            Keys.onReturnPressed: root.publishSpeed(inputField.text)
            Keys.onEnterPressed: root.publishSpeed(inputField.text)
        }

        Button {
            id: publishButton

            width: parent.width
            hoverEnabled: true

            text: qsTr("Publish")

            onClicked: root.publishSpeed(inputField.text)

            background: Rectangle {
                property color normalColor: "#008080"
                property color hoveredColor: "#00cccc"
                property color pressedColor: "#1affff"

                radius: 5
                color: publishButton.pressed ? pressedColor :
                       publishButton.hovered ? hoveredColor : normalColor
            }

            contentItem: Text {
                anchors.fill: parent

                text: publishButton.text
                font.pixelSize: 16
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
