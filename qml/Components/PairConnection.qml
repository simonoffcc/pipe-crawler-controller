import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    state: "global"

    width: 5
    height: 50

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

    MouseArea {
        enabled: false

        anchors.fill: parent
        propagateComposedEvents: true

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
