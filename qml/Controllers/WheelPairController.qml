import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import Components

import RobotController
import WheelsControllerName
import WheelsControllerState
import WheelJointName
import DriveMode
import PairsGroupingMode

Item {
    id: root

    property int wheelJointWidth: 115
    property int pairConnectionHeight: wheelJointWidth / 2.5
    property int elementStrokeWidth: 4
    property bool isFront: true
    property bool isLocked: false
    property bool speedPublishButtonOnLeft: false

    property int wheelPairName: WheelsControllerName.Unknown
    property int outerJointName: WheelJointName.Unknown
    property int innerJointName: WheelJointName.Unknown

    implicitWidth: wheelJointWidth
    implicitHeight: 2 * wheelJointWidth + pairConnectionHeight

    readonly property bool isCustomMode: RobotController.currentPairsGroupingMode === PairsGroupingMode.Custom &&
                                      RobotController.currentDriveMode === DriveMode.Custom

    MouseArea {
        id: clickArea
        enabled: root.isCustomMode && !root.isLocked

        anchors.fill: parent

        // hoverEnabled: true
        cursorShape: (root.isCustomMode && !root.isLocked) ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: root.changePairState()
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
            anchors.leftMargin = root.wheelJointWidth / 8
            anchors.rightMargin = root.wheelJointWidth / 8
            anchors.verticalCenter = connectionLine.verticalCenter
            speedPublishButtonOnLeft ? anchors.right = connectionLine.left : anchors.left = connectionLine.right
        }
    }

    WheelJoint {
        id: outerJoint

        width: root.wheelJointWidth
        height: width
        border.width: root.elementStrokeWidth
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

        height: root.pairConnectionHeight
        width: root.elementStrokeWidth
    }

    WheelJoint {
        id: innerJoint

        width: root.wheelJointWidth
        height: width
        border.width: root.elementStrokeWidth
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

    function changePairState() {
        let newState;
        if (root.state === "global") {
            newState = "local";
            RobotController.setWheelsControllerState(root.wheelPairName, WheelsControllerState.Local);
        }
        else if (root.state === "local") {
            newState = "independent";
            RobotController.setWheelsControllerState(root.wheelPairName, WheelsControllerState.Independent);
        }
        else {
            newState = "global";
            RobotController.setWheelsControllerState(root.wheelPairName, WheelsControllerState.Global);
        }
        outerJoint.clearSpeedInput();
        innerJoint.clearSpeedInput();
        root.state = newState;
    }

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
            let controllers = RobotController.controllers;
            for (let i = 0; i < controllers.length; i++) {
                if (controllers[i].name === root.wheelPairName) {
                    root.state = ["global", "local", "independent"][controllers[i].state];
                    outerJoint.telemetrySpeedValue = controllers[i].outerJoint.velocity.toFixed(2);
                    innerJoint.telemetrySpeedValue = controllers[i].innerJoint.velocity.toFixed(2);
                    outerJoint.telemetryEffortValue = controllers[i].outerJoint.effort.toFixed(1);
                    innerJoint.telemetryEffortValue = controllers[i].innerJoint.effort.toFixed(1);
                    break;
                }
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

    Component.onCompleted: {
        let controllers = RobotController.controllers;
        for (let i = 0; i < controllers.length; i++) {
            if (controllers[i].name === root.wheelPairName) {
                root.state = ["global", "local", "independent"][controllers[i].state];
                outerJoint.telemetrySpeedValue = controllers[i].outerJoint.velocity.toFixed(2);
                innerJoint.telemetrySpeedValue = controllers[i].innerJoint.velocity.toFixed(2);
                outerJoint.telemetryEffortValue = controllers[i].outerJoint.effort.toFixed(1);
                innerJoint.telemetryEffortValue = controllers[i].innerJoint.effort.toFixed(1);
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
