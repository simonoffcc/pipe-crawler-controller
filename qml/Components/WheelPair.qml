import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import WheelController
import controllerName
import jointName

Item {
    id: root

    property int controllerName: ControllerName.Unknown
    property bool isFront: true
    property bool isPublishButtonOnLeftSide: false
    property int jointControlWidth: 100
    property int elementStrokeWidth: 4
    property int outerJointName: JointName.Unknown
    property int innerJointName: JointName.Unknown

    state: "global"

    width: jointControlWidth
    height: jointControlWidth * 2.5

    Connections {
        target: WheelController
        
        function onActiveControllersChanged() {
            root.state = "local"
            var controllers = WheelController.activeControllers
            for (var i = 0; i < controllers.length; i++) {
                if (controllers[i] === root.controllerName) {
                    root.state = "global"
                }
            }
        }

        function onJointSpeedsChanged() {
            var speeds = WheelController.jointSpeeds
            
            if (outerJointName in speeds) {
                outerJoint.telemetrySpeed = speeds[outerJointName].toFixed(1) + "°/sec"
            }
            if (innerJointName in speeds) {
                innerJoint.telemetrySpeed = speeds[innerJointName].toFixed(1) + "°/sec"
            }
        }
    }

    MouseArea {
        id: clickArea
        enabled: false

        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (root.state === "global") { root.state = "local" }
            else if (root.state === "local") { root.state = "independent" }
            else { root.state = "global" }
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
            property color normalColor: "#000000"
            property color hoveredColor: "#333333"
            property color pressedColor: "#666666"

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
        jointName: root.outerJointName

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
        jointName: root.innerJointName

        Component.onCompleted: {
            anchors.horizontalCenter = parent.horizontalCenter
            !isFront ? anchors.bottom = connectionLine.top : anchors.top = connectionLine.bottom
        }
    }

    states: [
        State {
            name: "global"
            PropertyChanges {
                target: outerJoint
                state: "global"
            }
            PropertyChanges {
                target: connectionLine
                state: "global"
            }
            PropertyChanges {
                target: innerJoint
                state: "global"
            }
        },
        State {
            name: "local"
            PropertyChanges {
                target: outerJoint
                state: "local"
            }
            PropertyChanges {
                target: connectionLine
                state: "local"
            }
            PropertyChanges {
                target: innerJoint
                state: "local"
            }
            // PropertyChanges {
            //     publishButton.visible: true
            // }
        },
        State {
            name: "independent"
            PropertyChanges {
                target: outerJoint
                state: "local"
            }
            PropertyChanges {
                target: connectionLine
                state: "independent"
            }
            PropertyChanges {
                target: innerJoint
                state: "local"
            }
            // PropertyChanges {
            //     publishButton.visible: true
            // }
        }
    ]
}
