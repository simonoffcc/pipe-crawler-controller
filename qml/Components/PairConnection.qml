import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root

    property bool isConnected: false

    color: isConnected ? "black" : "green"
    border.color: "transparent"

    width: 5
    height: 50

    states: [
        State {
            name: "connected"
            when: isConnected
            PropertyChanges {
                target: root
                color: "black"
                border.color: "transparent"
            }
        },
        State {
            name: "disconnected"
            when: !isConnected
            PropertyChanges {
                target: root
                color: "green"
                border.color: "transparent"
            }
        },
        State {
            name: "dashed"
            when: false
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
        anchors.fill: parent

        onClicked: {
            if (root.state === "connected") {
                root.state = "disconnected"
            } else if (root.state === "disconnected") {
                root.state = "dashed"
            } else {
                root.state = "connected"
            }
            dashedLine.requestPaint();
        }
    }
}
