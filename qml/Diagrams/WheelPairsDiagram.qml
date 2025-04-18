import QtQuick
import QtQuick.Controls

import Components

import controllerName
import jointName

Item {
    id: root

    width: 430
    height: 910

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

        width: 400 /*schemeBody.width * 2.5*/
        height: schemeBody.height * 2
    }

    SchemeLines {
        id: schemeLinesBack

        isStraightUp: false

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: schemeBody.bottom
        }

        width: 400 /*schemeBody.width * 2.5*/
        height: schemeBody.height * 2
    }

    WheelPair {
        id: front_left

        controllerName: ControllerName.FrontLeft
        isFront: true
        isSpeedPublishButtonOnLeft: false
        isRayPositionPublishButtonOnLeft: true
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

        controllerName: ControllerName.FrontUp
        isFront: true
        isSpeedPublishButtonOnLeft: true
        isRayPositionPublishButtonOnLeft: false
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

        controllerName: ControllerName.FrontRight
        isFront: true
        isSpeedPublishButtonOnLeft: true
        isRayPositionPublishButtonOnLeft: false
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

        controllerName: ControllerName.BackLeft
        isFront: false
        isSpeedPublishButtonOnLeft: false
        isRayPositionPublishButtonOnLeft: true
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

        controllerName: ControllerName.BackUp
        isFront: false
        isSpeedPublishButtonOnLeft: false
        isRayPositionPublishButtonOnLeft: true
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

        controllerName: ControllerName.BackRight
        isFront: false
        isSpeedPublishButtonOnLeft: true
        isRayPositionPublishButtonOnLeft: false
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
