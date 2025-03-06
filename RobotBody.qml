import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic

Rectangle {
    id: root

    color: "#EEEEEE"
    radius: 15
    border.color: "gray"
    border.width: 1

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

            background: Rectangle {
                color: "transparent"
                border.color: "black"
                border.width: 1
                height: 1
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }

        Button {
            id: publishButton
            width: parent.width
            text: "Publish"
            background: Rectangle {
                color: "green"
                radius: 5
            }
            contentItem: Text {
                text: publishButton.text
                font.pixelSize: 16
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
            }
        }
    }
}
