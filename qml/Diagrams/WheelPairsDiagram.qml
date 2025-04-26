import QtQuick
import QtQuick.Controls

import Components
import Controllers

import wheelsControllerName
import wheelJointName

Item {
    id: root

    implicitWidth: 430
    implicitHeight: 910

    property int schemeBodyWidth: 150
    property int schemeBodyHeight: schemeBodyWidth
    property int schemeLinesWidth: 390
    property int schemeLinesHeight: 250
    property bool isLocked: false

    SchemeBody {
        id: schemeBody

        anchors.centerIn: parent

        implicitWidth: schemeBodyWidth
        implicitHeight: schemeBodyHeight
    }

    SchemeLines {
        id: schemeLinesFront
        title: "Front"
        isStraightUp: true

        width: schemeLinesWidth
        height: schemeLinesHeight

        Component.onCompleted: {
            anchors.horizontalCenter = parent.horizontalCenter
            anchors.bottom = schemeBody.top
        }
    }

    SchemeLines {
        id: schemeLinesBack
        title: "Back"
        isStraightUp: false

        width: schemeLinesWidth
        height: schemeLinesHeight

        Component.onCompleted: {
            anchors.horizontalCenter = parent.horizontalCenter
            anchors.top = schemeBody.bottom
        }
    }

    WheelPairController {
        id: front_left

        wheelPairName: WheelsControllerName.FrontLeft
        outerJointName: WheelJointName.FrontLeftOuter
        innerJointName: WheelJointName.FrontLeftInner
        speedPublishButtonOnLeft: false
        isLocked: root.isLocked
        isFront: true

        Component.onCompleted: {
            anchors.horizontalCenter = schemeLinesFront.left
            anchors.verticalCenter = schemeLinesFront.verticalCenter
            anchors.verticalCenterOffset = schemeLinesFront.height / 6
        }
    }

    WheelPairController {
        id: front_up

        wheelPairName: WheelsControllerName.FrontUp
        outerJointName: WheelJointName.FrontUpOuter
        innerJointName: WheelJointName.FrontUpInner
        speedPublishButtonOnLeft: true
        isLocked: root.isLocked
        isFront: true

        Component.onCompleted: {
            anchors.horizontalCenter = schemeLinesFront.horizontalCenter
            anchors.verticalCenter = schemeLinesFront.top
        }
    }

    WheelPairController {
        id: front_right

        wheelPairName: WheelsControllerName.FrontRight
        outerJointName: WheelJointName.FrontRightOuter
        innerJointName: WheelJointName.FrontRightInner
        speedPublishButtonOnLeft: true
        isLocked: root.isLocked
        isFront: true

        Component.onCompleted: {
            anchors.horizontalCenter = schemeLinesFront.right
            anchors.verticalCenter = schemeLinesFront.verticalCenter
            anchors.verticalCenterOffset = schemeLinesFront.height / 6
        }
    }

    WheelPairController {
        id: back_left

        wheelPairName: WheelsControllerName.BackLeft
        outerJointName: WheelJointName.BackLeftOuter
        innerJointName: WheelJointName.BackLeftInner
        speedPublishButtonOnLeft: false
        isLocked: root.isLocked
        isFront: false

        Component.onCompleted: {
            anchors.horizontalCenter = schemeLinesBack.left
            anchors.verticalCenter = schemeLinesBack.verticalCenter
            anchors.verticalCenterOffset = schemeLinesBack.height / -6
        }
    }

    WheelPairController {
        id: back_up

        wheelPairName: WheelsControllerName.BackUp
        outerJointName: WheelJointName.BackUpOuter
        innerJointName: WheelJointName.BackUpInner
        speedPublishButtonOnLeft: false
        isLocked: root.isLocked
        isFront: false


        Component.onCompleted: {
            anchors.horizontalCenter = schemeLinesBack.horizontalCenter
            anchors.verticalCenter = schemeLinesBack.bottom
        }
    }

    WheelPairController {
        id: back_right

        wheelPairName: WheelsControllerName.BackRight
        outerJointName: WheelJointName.BackRightOuter
        innerJointName: WheelJointName.BackRightInner
        speedPublishButtonOnLeft: true
        isLocked: root.isLocked
        isFront: false

        Component.onCompleted: {
            anchors.horizontalCenter = schemeLinesBack.right
            anchors.verticalCenter = schemeLinesBack.verticalCenter
            anchors.verticalCenterOffset = schemeLinesBack.height / -6
        }
    }
}

