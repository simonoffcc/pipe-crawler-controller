import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import RobotController
import WheelJointName
import PairsGroupingMode
import DriveMode

Rectangle {
    id: root

    property int jointName: WheelJointName.Unknown
    property double telemetrySpeedValue: 0.0
    property double telemetryEffortValue: 0.0
    property alias jointSpeedInput: speedInput.text
    property bool isPaired: false
    property var pairedJoint: null
    property bool isLocked: false

    signal speedSubmitted(string speed)

    state: "global"

    implicitWidth: 100
    implicitHeight: implicitWidth

    radius: width / 2
    border.width: 4
    color: "#f2f2f2"

    readonly property bool isCustomMode: RobotController.currentPairsGroupingMode === PairsGroupingMode.Custom &&
                                      RobotController.currentDriveMode === DriveMode.Custom

    Column {
        anchors.centerIn: parent
        spacing: 6

        Text {
            id: telemetryEffort

            anchors.horizontalCenter: parent.horizontalCenter

            text: root.telemetryEffortValue + qsTr(" H")
            font.pixelSize: 13
            color: "black"
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: telemetrySpeed

            anchors.horizontalCenter: parent.horizontalCenter

            text: root.telemetrySpeedValue + qsTr("°/sec")
            font.pixelSize: 13
            color: "black"
            horizontalAlignment: Text.AlignHCenter
        }

        TextField {
            id: speedInput
            visible: root.isCustomMode && root.state !== "global"

            width: root.width * 0.7
            height: 25
            anchors.horizontalCenter: parent.horizontalCenter

            color: "black"
            placeholderText: qsTr("dq: 1.0°/sec")
            placeholderTextColor: "gray"
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter

            ToolTip.text: qsTr("press \"Enter\" to publish")
            ToolTip.visible: speedInput.text !== "" && speedInput.activeFocus
            ToolTip.delay: 300
            ToolTip.timeout: 3000

            validator: DoubleValidator {
                notation: DoubleValidator.StandardNotation
            }

            background: Rectangle {
                color: "#f2f2f2"
                border.color: "black"
                border.width: 1
                height: 1

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }

            onTextChanged: {
                if (text !== "") {
                    root.syncSpeedWithPaired(text);
                }
            }

            function emitInputText() {
                if (text !== "") {
                    speedInput.focus = false;
                    root.speedSubmitted(text);
                }
            }

            onAccepted: emitInputText()
        }
    }

    MouseArea {
        enabled: false
        visible: false

        anchors.fill: parent

        onClicked: {
            if (root.state === "global") { root.state = "local"; }
            else if (root.state === "local") { root.state = "independent"; }
            else { root.state = "global"; }
        }
    }

    function clearSpeedInput() {
        speedInput.clear();
    }

    function syncSpeedWithPaired(speed) {
        if (isPaired && pairedJoint && root.state === "local" && root.isCustomMode) {
            pairedJoint.jointSpeedInput = speed;
        }
    }

    states: [
        State {
            name: "global"
            PropertyChanges {
                target: root
                border.color: "#008080"
            }
            PropertyChanges {
                target: speedInput
                focus: false;
            }
        },
        State {
            name: "local"
            PropertyChanges {
                target: root
                border.color: "#333333"
            }
            PropertyChanges {
                target: speedInput
                focus: false;
            }
        },
        State {
            name: "independent"
            PropertyChanges {
                target: root
                border.color: "#333333"
            }
            PropertyChanges {
                target: speedInput
                focus: false;
            }
        }
    ]
}
