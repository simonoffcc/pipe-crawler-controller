import QtQuick

Rectangle {
    id: root

    property alias hintText: text.text

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2
    rotation: -parent.rotation
    implicitWidth: text.width + text.font.pixelSize
    implicitHeight: text.height + text.font.pixelSize
    radius: 7
    color: "lightgray"
    border.color: "#a6a6a6"

    Text {
        id: text
        anchors.centerIn: parent
        font.bold: true
        font.pixelSize: 13
        color: "#666666"
        text: qsTr("undefined")
    }
}
