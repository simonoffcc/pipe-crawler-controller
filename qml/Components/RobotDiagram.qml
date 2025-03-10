import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    WheelPair {
        id: front_left_wheels_controller

        isFront: true
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesFront.left
            verticalCenter: schemeLinesFront.verticalCenter
            verticalCenterOffset: schemeLinesFront.height / 6
        }

        width: 100
        height: 100
    }

    WheelPair {
        id: front_up_wheels_controller

        isFront: true
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesFront.horizontalCenter
            verticalCenter: schemeLinesFront.top
        }

        width: 100
        height: 100
    }

    WheelPair {
        id: front_right_wheels_controller

        isFront: true
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesFront.right
            verticalCenter: schemeLinesFront.verticalCenter
            verticalCenterOffset: schemeLinesFront.height / 6
        }

        width: 100
        height: 100
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

    SchemeBody {
        id: schemeBody

        anchors.centerIn: parent

        width: 130
        height: 130
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
        id: back_left_wheels_controller

        isFront: false
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesBack.left
            verticalCenter: schemeLinesBack.verticalCenter
            verticalCenterOffset:  schemeLinesBack.height / -6
        }

        width: 100
        height: 100
    }

    WheelPair {
        id: back_up_wheels_controller

        isFront: false
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesBack.horizontalCenter
            verticalCenter: schemeLinesBack.bottom
        }

        width: 100
        height: 100
    }

    WheelPair {
        id: back_right_wheels_controller

        isFront: false
        elementStrokeWidth: 4

        anchors {
            horizontalCenter: schemeLinesBack.right
            verticalCenter: schemeLinesBack.verticalCenter
            verticalCenterOffset: schemeLinesBack.height / -6
        }

        width: 100
        height: 100
    }
}
