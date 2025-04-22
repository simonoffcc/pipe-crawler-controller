import QtQuick
import QtQuick.Controls

import Components

import wheelPairName
import jointName

Item {
    id: root

    implicitWidth: 430
    implicitHeight: 910

    property bool isLocked: false

    SchemeBody {
        id: schemeBody

        anchors.centerIn: parent

        width: 130
        height: 130
    }

    SchemeLines {
        id: schemeLinesFront

        isStraightUp: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: schemeBody.top
        }

        width: schemeBody.width * 3
        height: schemeBody.height * 2
    }

    SchemeLines {
        id: schemeLinesBack

        isStraightUp: false

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: schemeBody.bottom
        }

        width: schemeBody.width * 3
        height: schemeBody.height * 2
    }

    WheelPair {
        id: front_left

        wheelPairName: WheelPairName.FrontLeft
        isFront: true
        isSpeedPublishButtonOnLeft: false
        jointControlWidth: 100
        elementStrokeWidth: 4
        outerJointName: JointName.FrontLeftOuter
        innerJointName: JointName.FrontLeftInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesFront.left
            verticalCenter: schemeLinesFront.verticalCenter
            verticalCenterOffset: schemeLinesFront.height / 6
        }
    }

    WheelPair {
        id: front_up

        wheelPairName: WheelPairName.FrontUp
        isFront: true
        isSpeedPublishButtonOnLeft: true
        jointControlWidth: 100
        elementStrokeWidth: 4
        outerJointName: JointName.FrontUpOuter
        innerJointName: JointName.FrontUpInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesFront.horizontalCenter
            verticalCenter: schemeLinesFront.top
        }
    }

    WheelPair {
        id: front_right

        wheelPairName: WheelPairName.FrontRight
        isFront: true
        isSpeedPublishButtonOnLeft: true
        jointControlWidth: 100
        elementStrokeWidth: 4
        outerJointName: JointName.FrontRightOuter
        innerJointName: JointName.FrontRightInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesFront.right
            verticalCenter: schemeLinesFront.verticalCenter
            verticalCenterOffset: schemeLinesFront.height / 6
        }
    }

    WheelPair {
        id: back_left

        wheelPairName: WheelPairName.BackLeft
        isFront: false
        isSpeedPublishButtonOnLeft: false
        jointControlWidth: 100
        elementStrokeWidth: 4
        outerJointName: JointName.BackLeftOuter
        innerJointName: JointName.BackLeftInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesBack.left
            verticalCenter: schemeLinesBack.verticalCenter
            verticalCenterOffset: schemeLinesBack.height / -6
        }
    }

    WheelPair {
        id: back_up

        wheelPairName: WheelPairName.BackUp
        isFront: false
        isSpeedPublishButtonOnLeft: false
        jointControlWidth: 100
        elementStrokeWidth: 4
        outerJointName: JointName.BackUpOuter
        innerJointName: JointName.BackUpInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesBack.horizontalCenter
            verticalCenter: schemeLinesBack.bottom
        }
    }

    WheelPair {
        id: back_right

        wheelPairName: WheelPairName.BackRight
        isFront: false
        isSpeedPublishButtonOnLeft: true
        jointControlWidth: 100
        elementStrokeWidth: 4
        outerJointName: JointName.BackRightOuter
        innerJointName: JointName.BackRightInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesBack.right
            verticalCenter: schemeLinesBack.verticalCenter
            verticalCenterOffset: schemeLinesBack.height / -6
        }
    }
}
