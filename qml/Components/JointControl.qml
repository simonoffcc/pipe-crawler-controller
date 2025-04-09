import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import WheelController
import pairsGroupingMode
import driveMode

Rectangle {
    id: root

    property int jointName
    property alias telemetrySpeed: telemetryText.text
    property alias jointSpeed: speedInput.text
    property bool isPaired: false  // Flag to indicate if this joint is paired
    property var pairedJoint: null // Reference to the paired JointControl

    signal speedSubmitted(string speed)

    state: "global"

    width: 100
    height: width

    radius: width / 2
    border.width: 4
    color: "white"

    readonly property bool isCustomMode: WheelController.currentPairsGroupingMode === PairsGroupingMode.Custom &&
                                      WheelController.currentDriveMode === DriveMode.Custom

    // Function to sync speed with paired joint
    function syncSpeedWithPaired(speed) {
        if (isPaired && pairedJoint && root.state === "local" && root.isCustomMode) {
            pairedJoint.jointSpeed = speed;
            pairedJoint.speedSubmitted(speed);
        }
    }

    MouseArea {
        enabled: false

        anchors.fill: parent
        propagateComposedEvents: true

        onClicked: root.state === "global" ? root.state = "local" : root.state = "global"
    }

    Column {
        anchors.centerIn: parent
        spacing: 5

        Text {
            id: telemetryText

            text: qsTr("0.0°/sec")
            font.pixelSize: 14

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
            font.pixelSize: 12

            width: root.width * 0.7
            height: 25

            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter

            validator: DoubleValidator {
                notation: DoubleValidator.StandardNotation
            }

            background: Rectangle {
                color: "white"
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
                    root.speedSubmitted(text);
                }
            }

            Keys.onEnterPressed: {
                if (text !== "") {
                    root.speedSubmitted(text);
                }
            }
        }
    }

    states: [
        State {
            name: "global"
            PropertyChanges {
                target: root
                border.color: "green"
            }
        },
        State {
            name: "local"
            PropertyChanges {
                target: root
                border.color: "black"
            }
        },
        State {
            name: "independent"
            PropertyChanges {
                target: root
                border.color: "black"
            }
        }
    ]
}
