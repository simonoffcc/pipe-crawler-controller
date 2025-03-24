import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    state: "globalConnection"

    width: 5
    height: 50

    Canvas {
        id: dashedLine

        anchors.fill: parent
        visible: false

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, root.width, root.height);
            ctx.strokeStyle = "black";
            ctx.lineWidth = root.width;
            ctx.setLineDash([root.border.width / 2, root.border.width / 2]);
            ctx.beginPath();
            ctx.moveTo(root.width / 2, 0);
            ctx.lineTo(root.width / 2, root.height);
            ctx.stroke();
        }
    }

    MouseArea {
        enabled: false

        anchors.fill: parent
        propagateComposedEvents: true

        onClicked: {
            if (root.state === "globalConnection") {
                root.state = "localConnection"
            } else if (root.state === "localConnection") {
                root.state = "independentConnection"
            } else {
                root.state = "globalConnection"
            }
        }
    }

    states: [
        State {
            name: "globalConnection"
            PropertyChanges {
                target: root
                color: "green"
                border.color: "transparent"
            }
            PropertyChanges {
                target: dashedLine
                visible: false
            }
        },
        State {
            name: "localConnection"
            PropertyChanges {
                target: root
                color: "black"
                border.color: "transparent"
            }
            PropertyChanges {
                target: dashedLine
                visible: false
            }
        },
        State {
            name: "independentConnection"
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
