import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 2.15

Item {
    id: root

    Shape {
        id: layout

        anchors.fill: parent

        ShapePath {
            id: path

            strokeWidth: 2
            strokeColor: "black"

            startX: width / 2; startY: path.strokeWidth

            PathLine { x: width / 4; y: path.strokeWidth }
            PathLine { x: width / 4 ; y: 2 * height / 3 }
            PathLine { x: 0; y: 2 * height / 3 }
            PathLine { x: width; y: 2 * height / 3 }
            PathLine { x: width / 2; y: 2 * height / 3 }
            PathLine { x: width / 2; y: height}
        }
    }
}
