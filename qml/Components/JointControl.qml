import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic

Rectangle {
    id: root

    property alias telemetrySpeed: telemetryText.text
    property alias jointSpeed: speedInput.text

    state: "globalSpeedControl"

    radius: width / 2
    border.width: 4
    color: "white"

    width: 100
    height: width

    MouseArea {
        id: clickArea

        anchors.fill: parent

        onClicked: root.state === "globalSpeedControl" ? root.state = "localSpeedControl" : root.state = "globalSpeedControl"
    }

    Column {
        anchors.centerIn: parent
        spacing: 5

        Text {
            id: telemetryText
            text: qsTr("0°/sec")
            font.pixelSize: 14

            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter

            color: "black"
        }

        TextField {
            id: speedInput

            color: "black"
            placeholderText: qsTr("dq: 1°/sec")
            placeholderTextColor: "gray"
            font.pixelSize: 12

            width: root.width * 0.7
            height: 25

            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter

            validator: DoubleValidator {
                notation: DoubleValidator.StandardNotation
            }

            background: Rectangle {
                color: "white"
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
    }

    states: [
        State {
            name: "globalSpeedControl"
            PropertyChanges {
                root.border.color: "green"
                speedInput.visible: false
            }
        },
        State {
            name: "localSpeedControl"
            PropertyChanges {
                root.border.color: "black"
                speedInput.visible: true
            }
        }
    ]
}
