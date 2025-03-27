import QtQuick
import QtQuick.Controls

Item {
    id: root

    width: 430
    height: 910

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

        width: schemeBody.width * 2.5
        height: schemeBody.height * 2
    }

    SchemeLines {
        id: schemeLinesBack

        isStraightUp: false

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: schemeBody.bottom
        }

        width: schemeBody.width * 2.5
        height: schemeBody.height * 2
    }

    WheelPair {
        id: front_left

        isFront: true
        isPublishButtonOnLeftSide: true
        jointControlWidth: 100
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesFront.left
            verticalCenter: schemeLinesFront.verticalCenter
            verticalCenterOffset: schemeLinesFront.height / 6
        }
    }

    WheelPair {
        id: front_up

        isFront: true
        isPublishButtonOnLeftSide: false
        jointControlWidth: 100
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesFront.horizontalCenter
            verticalCenter: schemeLinesFront.top
        }
    }

    WheelPair {
        id: front_right

        isFront: true
        isPublishButtonOnLeftSide: false
        jointControlWidth: 100
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesFront.right
            verticalCenter: schemeLinesFront.verticalCenter
            verticalCenterOffset: schemeLinesFront.height / 6
        }
    }

    WheelPair {
        id: back_left

        isFront: false
        isPublishButtonOnLeftSide: true
        jointControlWidth: 100
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesBack.left
            verticalCenter: schemeLinesBack.verticalCenter
            verticalCenterOffset:  schemeLinesBack.height / -6
        }
    }

    WheelPair {
        id: back_up

        isFront: false
        isPublishButtonOnLeftSide: true
        jointControlWidth: 100
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesBack.horizontalCenter
            verticalCenter: schemeLinesBack.bottom
        }
    }

    WheelPair {
        id: back_right

        isFront: false
        isPublishButtonOnLeftSide: false
        jointControlWidth: 100
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesBack.right
            verticalCenter: schemeLinesBack.verticalCenter
            verticalCenterOffset: schemeLinesBack.height / -6
        }
    }
}
