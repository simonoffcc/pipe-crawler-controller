import QtQuick
import QtQuick.Controls

import Components
import Controllers

import WheelsControllerName
import WheelJointName

Item {
    id: root

    implicitWidth: schemeLinesWidth + frontLeftPair.width
    implicitHeight: schemeLinesHeight + schemeBodyHeight + (frontUpPair.width / 2)

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
        id: frontLeftPair

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
        id: frontUpPair

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
        id: frontRightPair

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
        id: backLeftPair

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
        id: backUpPair

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
        id: backRightPair

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

