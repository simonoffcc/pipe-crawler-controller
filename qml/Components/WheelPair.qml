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

    state: "global"

    width: jointControlWidth
    height: jointControlWidth * 2.5

    readonly property bool isCustomMode: WheelController.currentPairsGroupingMode === PairsGroupingMode.Custom && 
                                      WheelController.currentDriveMode === DriveMode.Custom

    property var drivingModesPanel: null

    readonly property bool canChangeState: isCustomMode && (!drivingModesPanel || !drivingModesPanel.isLocked)

    Component.onCompleted: {
        let parent = root.parent;
        while (parent) {
            if (parent.drivingModesPanel) {
                drivingModesPanel = parent.drivingModesPanel;
                break;
            }
            parent = parent.parent;
        }

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
                    if (!isCustomMode) {
                        root.state = ["global", "local", "independent"][controllers[i].state];
                    }
                    outerJoint.telemetrySpeed = controllers[i].outerJoint.velocity.toFixed(1) + "°/sec";
                    innerJoint.telemetrySpeed = controllers[i].innerJoint.velocity.toFixed(1) + "°/sec";
                    break;
                }
            }
            if (!found) {
                if (!isCustomMode) {
                    root.state = "global";
                }
                outerJoint.telemetrySpeed = "0.0°/sec";
                innerJoint.telemetrySpeed = "0.0°/sec";
            }
        }

        function onCurrentDriveModeChanged() {
            if (!isCustomMode) {
                root.state = "global";
            }
        }

        function onCurrentPairsGroupingModeChanged() {
            if (!isCustomMode) {
                root.state = "global";
            }
        }
    }

    MouseArea {
        id: clickArea
        enabled: root.canChangeState

        anchors.fill: parent

        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            if (enabled) {
                if (root.state === "global") { 
                    root.state = "local";
                }
                else if (root.state === "local") { 
                    root.state = "independent";
                }
                else { 
                    root.state = "global";
                }
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
        enabled: root.state !== "global"

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
        enabled: root.state !== "global"

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
            PropertyChanges {
                target: publishButton
                visible: false
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
            PropertyChanges {
                target: publishButton
                visible: true
            }
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
            PropertyChanges {
                target: publishButton
                visible: true
            }
        }
    ]
}
