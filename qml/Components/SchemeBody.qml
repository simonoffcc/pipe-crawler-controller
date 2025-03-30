import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import WheelController

Rectangle {
    id: root

    radius: 15
    border.color: "gray"
    border.width: 1
    color: "#EEEEEE"

    width: 130
    height: 130

    Column {
        anchors.centerIn: parent

        width: parent.width * 0.8
        spacing: 10

        TextField {
            id: inputField

            width: parent.width
            color: "black"
            placeholderText: "target_vel"
            placeholderTextColor: "gray"
            horizontalAlignment: TextInput.AlignHCenter
            font.pixelSize: 16
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
        }

        Button {
            id: publishButton

            width: parent.width
            hoverEnabled: true

            text: qsTr("Publish")

            background: Rectangle {
                property color normalColor: "#4CAF50"
                property color hoveredColor: "#45A049"
                property color pressedColor: "#3D8B40"

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

            onClicked: {
                console.log("Pairs grouping mode set to:", WheelController.currentPairsGroupingMode())
                console.log("Drive mode set to:", WheelController.currentDriveMode())
            }
        }
    }
}
