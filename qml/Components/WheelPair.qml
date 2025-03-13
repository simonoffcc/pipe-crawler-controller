import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic

Item {
    id: root

    property bool isFront: true
    property bool isPublishButtonOnLeftSide: false
    property int jointControlWidth: 100
    property int elementStrokeWidth: 4

    state: "globalSpeedControl"

    width: jointControlWidth
    height: jointControlWidth * 2.5

    MouseArea {
        id: clickArea

        anchors.fill: parent

        onClicked: {
            if (root.state === "globalSpeedControl") {
                root.state = "localSpeedControl"
            } else if (root.state === "localSpeedControl") {
                root.state = "independentSpeedControl"
            } else {
                root.state = "globalSpeedControl"
            }
        }
    }

    Button {
        id: publishButton
        visible: false

        width: jointControlWidth * 0.6
        height: jointControlWidth * 0.3
        hoverEnabled: true

        text: qsTr("Publish")

        background: Rectangle {

            property color normalColor: "black"
            property color hoveredColor: "lightgray"
            property color pressedColor: "darkgray"

            radius: 7
            color: publishButton.pressed ? pressedColor :
                   publishButton.hovered ? hoveredColor : normalColor
        }

        contentItem: Text {
            anchors.fill: parent

            text: publishButton.text
            font.pixelSize: 14
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Component.onCompleted: {
            anchors.leftMargin = jointControlWidth / 8
            anchors.rightMargin = jointControlWidth / 8
            anchors.verticalCenter = connectionLine.verticalCenter
            isPublishButtonOnLeftSide ? anchors.right = connectionLine.left : anchors.left = connectionLine.right
        }
    }

    JointControl {
        id: outerJoint

        width: jointControlWidth
        height: jointControlWidth
        border.width: elementStrokeWidth

        Component.onCompleted: {
            anchors.horizontalCenter = parent.horizontalCenter
            isFront ? anchors.bottom = connectionLine.top : anchors.top = connectionLine.bottom
        }
    }

    PairConnection {
        id: connectionLine

        anchors.centerIn: parent

        height: jointControlWidth / 2
        width: elementStrokeWidth
    }

    JointControl {
        id: innerJoint

        width: jointControlWidth
        height: jointControlWidth
        border.width: elementStrokeWidth

        Component.onCompleted: {
            anchors.horizontalCenter = parent.horizontalCenter
            !isFront ? anchors.bottom = connectionLine.top : anchors.top = connectionLine.bottom
        }
    }

    states: [
        State {
            name: "globalSpeedControl"
            PropertyChanges {
                target: outerJoint
                state: "globalControl"
            }
            PropertyChanges {
                target: connectionLine
                state: "globalConnection"
            }
            PropertyChanges {
                target: innerJoint
                state: "globalControl"
            }
        },
        State {
            name: "localSpeedControl"
            PropertyChanges {
                target: outerJoint
                state: "localControl"
            }
            PropertyChanges {
                target: connectionLine
                state: "localConnection"
            }
            PropertyChanges {
                target: innerJoint
                state: "localControl"
            }
            PropertyChanges {
                publishButton.visible: true
            }
        },
        State {
            name: "independentSpeedControl"
            PropertyChanges {
                target: outerJoint
                state: "independentControl"
            }
            PropertyChanges {
                target: connectionLine
                state: "independentConnection"
            }
            PropertyChanges {
                target: innerJoint
                state: "independentControl"
            }
            PropertyChanges {
                publishButton.visible: true
            }
        }
    ]
}
