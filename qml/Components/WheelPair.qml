import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import WheelController
import wheelPairName
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

    readonly property bool isCustomMode: WheelController.currentPairsGroupingMode === PairsGroupingMode.Custom &&
                                      WheelController.currentDriveMode === DriveMode.Custom
    readonly property int outputPrecision: 2

    function publishOnSpeedSubmitted(speed, isOuter) {
        if (root.state === "independent") {
            WheelController.publishIndependentSpeed(parseFloat(speed), root.wheelPairName, isOuter);
            if (isOuter) { outerJoint.clearSpeedInput(); } else { innerJoint.clearSpeedInput(); }
        }
        else if (root.state === "local") {
            WheelController.publishLocalSpeed(parseFloat(speed), root.wheelPairName);
            outerJoint.clearSpeedInput();
            innerJoint.clearSpeedInput();
        }
    }

    function publishOnButtonPressed(speed) {
        if (root.state === "local" && speed !== "") {
            WheelController.publishLocalSpeed(parseFloat(speed), root.wheelPairName);
            outerJoint.clearSpeedInput();
            innerJoint.clearSpeedInput();
        }
    }

    Connections {
        target: WheelController

        function onControllersChanged() {
            let found = false;
            let controllers = WheelController.controllers;
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
                WheelController.setWheelPairState(root.wheelPairName, 1);
            }
            else if (root.state === "local") {
                newState = "independent";
                WheelController.setWheelPairState(root.wheelPairName, 2);
            }
            else {
                newState = "global";
                WheelController.setWheelPairState(root.wheelPairName, 0);
            }
            outerJoint.clearSpeedInput();
            innerJoint.clearSpeedInput();
            root.state = newState;
        }
    }

    Button {
        id: publishButton
        visible: root.isCustomMode && root.state === "local"

        implicitWidth: 65
        implicitHeight: 25
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
        let controllers = WheelController.controllers;
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
