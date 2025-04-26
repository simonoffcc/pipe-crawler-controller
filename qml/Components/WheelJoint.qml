import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import RobotController
import pairsGroupingMode
import driveMode

Rectangle {
    id: root

    property int jointName
    property alias telemetrySpeed: telemetryText.text
    property alias jointSpeed: speedInput.text
    property bool isPaired: false
    property var pairedJoint: null
    property bool isLocked: false

    signal speedSubmitted(string speed)

    state: "global"

    width: 100
    height: width

    radius: width / 2
    border.width: 4
    color: "#f2f2f2"

    readonly property bool isCustomMode: RobotController.currentPairsGroupingMode === PairsGroupingMode.Custom &&
                                      RobotController.currentDriveMode === DriveMode.Custom

    Column {
        anchors.centerIn: parent
        spacing: 5

        Text {
            id: telemetryText

            text: qsTr("0.0°/sec")
            font.pixelSize: 13

            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter

            color: "black"
        }

        TextField {
            id: speedInput
            visible: root.isCustomMode && root.state !== "global"

            color: "black"
            placeholderText: qsTr("dq: 1.0°/sec")
            placeholderTextColor: "gray"
            font.pixelSize: 11

            width: root.width * 0.7
            height: 25

            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment: TextInput.AlignHCenter

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

            Keys.onReturnPressed: {
                if (text !== "") {
                    speedInput.focus = false;
                    root.speedSubmitted(text);
                }
            }

            Keys.onEnterPressed: {
                if (text !== "") {
                    speedInput.focus = false;
                    root.speedSubmitted(text);
                }
            }
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
        speedInput.text = "";
    }

    function syncSpeedWithPaired(speed) {
        if (isPaired && pairedJoint && root.state === "local" && root.isCustomMode) {
            pairedJoint.jointSpeed = speed;
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
