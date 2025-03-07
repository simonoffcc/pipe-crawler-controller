import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic

Rectangle {
    id: root

    property alias telemetrySpeed: telemetryText.text
    property alias jointSpeed: speedInput.text
    property bool wheelEnabled: false

    radius: width / 2
    border.color: wheelEnabled ? "black" : "green"
    color: "transparent"

    MouseArea {
        id: clickArea

        anchors.fill: parent

        onClicked: {
            wheelEnabled = !wheelEnabled;
        }
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

            width: root.width * 0.7
            height: 25

            color: "black"
            placeholderText: qsTr("dq: 1°/sec")
            placeholderTextColor: "gray"
            font.pixelSize: 12
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            visible: wheelEnabled

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
}
