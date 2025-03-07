import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    id: window
    width: 500
    height: 1000
    title: qsTr("Pipe Crawler Wheels Control")

    WheelPair {
        id: front_left_wheels_controller
        visible: true

        anchors.horizontalCenter: schemeLinesFront.left
        anchors.verticalCenter: schemeLinesFront.verticalCenter
        anchors.verticalCenterOffset: schemeLinesFront.height / 6

        width: 100
        height: 100
        elementStrokeWidth: 4
    }

    WheelPair {
        id: front_up_wheels_controller
        visible: true

        anchors.horizontalCenter: schemeLinesFront.horizontalCenter
        anchors.verticalCenter: schemeLinesFront.top

        width: 100
        height: 100
        elementStrokeWidth: 4
    }

    WheelPair {
        id: front_right_wheels_controller
        visible: true

        anchors.horizontalCenter: schemeLinesFront.right
        anchors.verticalCenter: schemeLinesFront.verticalCenter
        anchors.verticalCenterOffset: schemeLinesFront.height / 6

        width: 100
        height: 100
        elementStrokeWidth: 4
    }


    WheelPair {
        id: back_left_wheels_controller
        visible: true

        anchors.horizontalCenter: schemeLinesBack.left
        anchors.verticalCenter: schemeLinesBack.verticalCenter
        anchors.verticalCenterOffset:  schemeLinesBack.height / -6

        width: 100
        height: 100
        elementStrokeWidth: 4
    }

    WheelPair {
        id: back_up_wheels_controller
        visible: true

        anchors.horizontalCenter: schemeLinesBack.horizontalCenter
        anchors.verticalCenter: schemeLinesBack.bottom

        width: 100
        height: 100
        elementStrokeWidth: 4
    }

    WheelPair {
        id: back_right_wheels_controller
        visible: true

        anchors.horizontalCenter: schemeLinesBack.right
        anchors.verticalCenter: schemeLinesBack.verticalCenter
        anchors.verticalCenterOffset:  schemeLinesBack.height / -6

        width: 100
        height: 100
        elementStrokeWidth: 4
    }


    SchemeLines {
        id: schemeLinesFront
        visible: true

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: robotBody.top

        width: robotBody.width * 2.5
        height: robotBody.height * 2
    }

    RobotBody {
        id: robotBody
        visible: true

        anchors.centerIn: parent

        width: 130
        height: 130
    }

    SchemeLines {
        id: schemeLinesBack
        visible: true

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: robotBody.bottom

        rotation: 180
        width: robotBody.width * 2.5
        height: robotBody.height * 2
    }
}
