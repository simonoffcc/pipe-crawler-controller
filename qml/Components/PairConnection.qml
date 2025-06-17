import QtQuick
import QtQuick.Shapes
import QtQuick.Controls

Rectangle {
    id: root

    state: "global"

    implicitWidth: 5
    implicitHeight: 50

    Canvas {
        id: dashedLine

        anchors.fill: parent
        visible: false

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, root.width, root.height);
            ctx.strokeStyle = "#333333";
            ctx.lineWidth = root.width;
            ctx.setLineDash([root.border.width / 2, root.border.width / 2]);
            ctx.beginPath();
            ctx.moveTo(root.width / 2, 0);
            ctx.lineTo(root.width / 2, root.height);
            ctx.stroke();
        }
    }

    // Shape {
    //     id: dashedLineShape
    //     anchors.fill: parent
    //     visible: false

    //     ShapePath {
    //         fillColor: "transparent"
    //         strokeColor: "#333333"
    //         strokeWidth: root.width
    //         strokeStyle: ShapePath.DashLine
    //         dashPattern: [ 2, 3 ]
    //         startX: root.width / 2; startY: 0
    //         PathLine { x: root.width / 2; y: root.height}
    //     }
    // }

    MouseArea {
        enabled: false
        visible: false

        anchors.fill: parent

        onClicked: {
            if (root.state === "global") {
                root.state = "local"
            } else if (root.state === "local") {
                root.state = "independent"
            } else {
                root.state = "global"
            }
        }
    }

    states: [
        State {
            name: "global"
            PropertyChanges {
                target: root
                color: "#008080"
                border.color: "transparent"
            }
            PropertyChanges {
                target: dashedLine
                visible: false
            }
        },
        State {
            name: "local"
            PropertyChanges {
                target: root
                color: "#333333"
                border.color: "transparent"
            }
            PropertyChanges {
                target: dashedLine
                visible: false
            }
        },
        State {
            name: "independent"
            PropertyChanges {
                target: root
                color: "transparent"
                border.color: "transparent"
            }
            PropertyChanges {
                target: dashedLine
                visible: true
            }
        }
    ]
}
