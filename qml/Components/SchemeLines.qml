import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property bool isStraightUp: true
    property int linesWidth: 2

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
}
