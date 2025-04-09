import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import WheelController
import controllerName
import jointName
import driveMode
import pairsGroupingMode

Item {
    id: root

    property int controllerName: ControllerName.Unknown
    property bool isFront: true
    property bool isPublishButtonOnLeftSide: false
    property int jointControlWidth: 100
    property int elementStrokeWidth: 4
    property int outerJointName: JointName.Unknown
    property int innerJointName: JointName.Unknown
    property bool isLocked: false

    width: jointControlWidth
    height: jointControlWidth * 2.5

    readonly property bool isCustomMode: WheelController.currentPairsGroupingMode === PairsGroupingMode.Custom &&
                                      WheelController.currentDriveMode === DriveMode.Custom

    Component.onCompleted: {
        let controllers = WheelController.controllers;
        for (let i = 0; i < controllers.length; i++) {
            if (controllers[i].name === root.controllerName) {
                root.state = ["global", "local", "independent"][controllers[i].state];
                outerJoint.telemetrySpeed = controllers[i].outerJoint.velocity.toFixed(1) + "°/sec";
                innerJoint.telemetrySpeed = controllers[i].innerJoint.velocity.toFixed(1) + "°/sec";
                break;
            }
        }
    }

    Connections {
        target: WheelController
        
        function onControllersChanged() {
            let found = false;
            let controllers = WheelController.controllers;
            for (let i = 0; i < controllers.length; i++) {
                if (controllers[i].name === root.controllerName) {
                    found = true;
                    root.state = ["global", "local", "independent"][controllers[i].state];
                    outerJoint.telemetrySpeed = controllers[i].outerJoint.velocity.toFixed(1) + "°/sec";
                    innerJoint.telemetrySpeed = controllers[i].innerJoint.velocity.toFixed(1) + "°/sec";
                    break;
                }
            }
            if (!found) {
                root.state = "independent";
                outerJoint.telemetrySpeed = "0.0°/sec";
                innerJoint.telemetrySpeed = "0.0°/sec";
            }
        }

        function onDriveModeChanged() {
            if (!isCustomMode) {
                root.state = "global";
            }
        }

        function onPairsGroupingModeChanged() {
            if (!isCustomMode) {
                root.state = "global";
            }
        }
    }

    MouseArea {
        id: clickArea
        enabled: root.isCustomMode && !root.isLocked

        anchors.fill: parent

        cursorShape: (root.isCustomMode && !root.isLocked) ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            let newState;
            if (root.state === "global") { 
                newState = "local";
                WheelController.setControllerState(root.controllerName, 1); // LOCAL = 1
            }
            else if (root.state === "local") { 
                newState = "independent";
                WheelController.setControllerState(root.controllerName, 2); // INDEPENDENT = 2
            }
            else { 
                newState = "global";
                WheelController.setControllerState(root.controllerName, 0); // GLOBAL = 0
            }
            root.state = newState;
        }
    }

    Button {
        id: publishButton
        visible: root.isCustomMode && root.state !== "global"

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

        // onClicked: {
        //     if (root.state === "local" && outerJoint.jointSpeed !== "") {
        //         WheelController.publishLocalSpeed(parseFloat(outerJoint.jointSpeed), root.controllerName);
        //     }
        // }
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

        // onSpeedSubmitted: {
        //     if (root.state === "independent") {
        //         WheelController.publishIndependentSpeed(parseFloat(speed), root.controllerName, true);
        //     }
        // }
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

        // onSpeedSubmitted: {
        //     if (root.state === "independent") {
        //         WheelController.publishIndependentSpeed(parseFloat(speed), root.controllerName, false);
        //     }
        // }
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
            // PropertyChanges {
            //     target: publishButton
            //     visible: false
            // }
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
            //     target: publishButton
            //     visible: true
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
            //     target: publishButton
            //     visible: true
            // }
        }
    ]
}
