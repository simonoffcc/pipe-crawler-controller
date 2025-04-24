import QtQuick
import QtQuick.Controls

import Components

import wheelsControllerName
import wheelJointName

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
        title: "Front"
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
        title: "Back"
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

        wheelPairName: WheelsControllerName.FrontLeft
        isFront: true
        isSpeedPublishButtonOnLeft: false
        outerJointName: WheelJointName.FrontLeftOuter
        innerJointName: WheelJointName.FrontLeftInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesFront.left
            verticalCenter: schemeLinesFront.verticalCenter
            verticalCenterOffset: schemeLinesFront.height / 6
        }
    }

    WheelPair {
        id: front_up

        wheelPairName: WheelsControllerName.FrontUp
        isFront: true
        isSpeedPublishButtonOnLeft: true
        outerJointName: WheelJointName.FrontUpOuter
        innerJointName: WheelJointName.FrontUpInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesFront.horizontalCenter
            verticalCenter: schemeLinesFront.top
        }
    }

    WheelPair {
        id: front_right

        wheelPairName: WheelsControllerName.FrontRight
        isFront: true
        isSpeedPublishButtonOnLeft: true
        outerJointName: WheelJointName.FrontRightOuter
        innerJointName: WheelJointName.FrontRightInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesFront.right
            verticalCenter: schemeLinesFront.verticalCenter
            verticalCenterOffset: schemeLinesFront.height / 6
        }
    }

    WheelPair {
        id: back_left

        wheelPairName: WheelsControllerName.BackLeft
        isFront: false
        isSpeedPublishButtonOnLeft: false
        outerJointName: WheelJointName.BackLeftOuter
        innerJointName: WheelJointName.BackLeftInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesBack.left
            verticalCenter: schemeLinesBack.verticalCenter
            verticalCenterOffset: schemeLinesBack.height / -6
        }
    }

    WheelPair {
        id: back_up

        wheelPairName: WheelsControllerName.BackUp
        isFront: false
        isSpeedPublishButtonOnLeft: false
        outerJointName: WheelJointName.BackUpOuter
        innerJointName: WheelJointName.BackUpInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesBack.horizontalCenter
            verticalCenter: schemeLinesBack.bottom
        }
    }

    WheelPair {
        id: back_right

        wheelPairName: WheelsControllerName.BackRight
        isFront: false
        isSpeedPublishButtonOnLeft: true       
        outerJointName: WheelJointName.BackRightOuter
        innerJointName: WheelJointName.BackRightInner
        isLocked: root.isLocked

        anchors {
            horizontalCenter: schemeLinesBack.right
            verticalCenter: schemeLinesBack.verticalCenter
            verticalCenterOffset: schemeLinesBack.height / -6
        }
    }
}
