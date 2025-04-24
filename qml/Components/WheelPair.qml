import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import RobotController
import wheelPairName
import wheelPairState
import jointName
import driveMode
import pairsGroupingMode

Item {
    id: root

    property int jointControlWidth: 100
    property int elementStrokeWidth: 4
    property bool isFront: true
    property bool isLocked: false
    property bool isSpeedPublishButtonOnLeft: false

    property int wheelPairName: WheelPairName.Unknown
    property int outerJointName: JointName.Unknown
    property int innerJointName: JointName.Unknown

    width: jointControlWidth
    height: jointControlWidth * 2.5

    readonly property bool isCustomMode: RobotController.currentPairsGroupingMode === PairsGroupingMode.Custom &&
                                      RobotController.currentDriveMode === DriveMode.Custom
    readonly property int outputPrecision: 2

    function publishOnSpeedSubmitted(speed, isOuter) {
        if (root.state === "independent") {
            RobotController.publishIndependentSpeed(parseFloat(speed), root.wheelPairName, isOuter);
            if (isOuter) { outerJoint.clearSpeedInput(); } else { innerJoint.clearSpeedInput(); }
        }
        else if (root.state === "local") {
            RobotController.publishLocalSpeed(parseFloat(speed), root.wheelPairName);
            outerJoint.clearSpeedInput();
            innerJoint.clearSpeedInput();
        }
    }

    function publishOnButtonPressed(speed) {
        if (root.state === "local" && speed !== "") {
            RobotController.publishLocalSpeed(parseFloat(speed), root.wheelPairName);
            outerJoint.clearSpeedInput();
            innerJoint.clearSpeedInput();
        }
    }

    Connections {
        target: RobotController

        function onControllersChanged() {
            let found = false;
            let controllers = RobotController.controllers;
            for (let i = 0; i < controllers.length; i++) {
                if (controllers[i].name === root.wheelPairName) {
                    found = true;
                    root.state = ["global", "local", "independent"][controllers[i].state];
                    outerJoint.telemetrySpeed = controllers[i].outerJoint.velocity.toFixed(outputPrecision) + "°/sec";
                    innerJoint.telemetrySpeed = controllers[i].innerJoint.velocity.toFixed(outputPrecision) + "°/sec";
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
            outerJoint.clearSpeedInput();
            innerJoint.clearSpeedInput();
        }

        function onPairsGroupingModeChanged() {
            if (!isCustomMode) {
                root.state = "global";
            }
            outerJoint.clearSpeedInput();
            innerJoint.clearSpeedInput();
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
                RobotController.setWheelPairState(root.wheelPairName, WheelPairState.Local);
            }
            else if (root.state === "local") {
                newState = "independent";
                RobotController.setWheelPairState(root.wheelPairName, WheelPairState.Independent);
            }
            else {
                newState = "global";
                RobotController.setWheelPairState(root.wheelPairName, WheelPairState.Global);
            }
            outerJoint.clearSpeedInput();
            innerJoint.clearSpeedInput();
            root.state = newState;
        }
    }

    Button {
        id: publishButton
        visible: root.isCustomMode && root.state === "local"

        implicitWidth: 60
        implicitHeight: 25
        hoverEnabled: true

        text: qsTr("Publish")

        background: Rectangle {
            property color normalColor: "#000000"
            property color hoveredColor: "#333333"
            property color pressedColor: "#666666"

            radius: 4
            color: publishButton.pressed ? pressedColor :
                   publishButton.hovered ? hoveredColor : normalColor

            border.color: enabled ? "#97999b" : "#bdbebf"
        }

        contentItem: Text {
            anchors.fill: parent

            text: publishButton.text
            font.pixelSize: 12
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        onClicked: root.publishOnButtonPressed(outerJoint.jointSpeed)

        Component.onCompleted: {
            anchors.leftMargin = jointControlWidth / 8
            anchors.rightMargin = jointControlWidth / 8
            anchors.verticalCenter = connectionLine.verticalCenter
            isSpeedPublishButtonOnLeft ? anchors.right = connectionLine.left : anchors.left = connectionLine.right
        }
    }

    JointControl {
        id: outerJoint

        width: jointControlWidth
        height: width
        border.width: elementStrokeWidth
        jointName: root.outerJointName
        isPaired: true
        pairedJoint: innerJoint
        isLocked: root.isLocked

        onSpeedSubmitted: function(speedValue) { root.publishOnSpeedSubmitted(speedValue, true) }

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
        height: width
        border.width: elementStrokeWidth
        jointName: root.innerJointName
        isPaired: true
        pairedJoint: outerJoint
        isLocked: root.isLocked

        onSpeedSubmitted: function(speedValue) { root.publishOnSpeedSubmitted(speedValue, false) }

        Component.onCompleted: {
            anchors.horizontalCenter = parent.horizontalCenter
            !isFront ? anchors.bottom = connectionLine.top : anchors.top = connectionLine.bottom
        }
    }

    Component.onCompleted: {
        let controllers = RobotController.controllers;
        for (let i = 0; i < controllers.length; i++) {
            if (controllers[i].name === root.wheelPairName) {
                root.state = ["global", "local", "independent"][controllers[i].state];
                outerJoint.telemetrySpeed = controllers[i].outerJoint.velocity.toFixed(outputPrecision) + "°/sec";
                innerJoint.telemetrySpeed = controllers[i].innerJoint.velocity.toFixed(outputPrecision) + "°/sec";
                break;
            }
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
        },
        State {
            name: "independent"
            PropertyChanges {
                target: outerJoint
                state: "independent"
            }
            PropertyChanges {
                target: connectionLine
                state: "independent"
            }
            PropertyChanges {
                target: innerJoint
                state: "independent"
            }
        }
    ]
}
