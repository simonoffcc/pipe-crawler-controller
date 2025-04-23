import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property bool isStraightUp: true
    property int linesWidth: 2
    property alias title: title.text

    rotation: isStraightUp ? 0 : 180
    width: 250
    height: 200

    Shape {
        anchors.fill: root

        ShapePath {
            id: path

            capStyle: ShapePath.FlatCap
            strokeWidth: linesWidth
            strokeColor: "#a6a6a6"
            fillColor: "transparent"

            startX: width / 2 - path.strokeWidth / 2; startY: path.strokeWidth
            PathLine { x: width / 4; y: path.strokeWidth }
            PathLine { x: width / 4; y: 2 * height / 3 }
            PathLine { x: 0; y: 2 * height / 3 }
            PathLine { x: width; y: 2 * height / 3 }
            PathLine { x: width / 2; y: 2 * height / 3 }
            PathLine { x: width / 2; y: height}
        }
    }

    Rectangle {
        id: hintTitle

        x: root.width / 2 - width / 2
        y: 2 * root.height / 3 - height / 2
        rotation: -root.rotation
        implicitWidth: title.width + title.font.pixelSize
        implicitHeight: title.height + title.font.pixelSize
        radius: 7
        color: "lightgray"
        border.color: "#a6a6a6"

        Text {
            id: title
            anchors.centerIn: parent
            font.bold: true
            font.pixelSize: 13
            color: "#666666"
            text: qsTr("undefined")
        }
    }
}
