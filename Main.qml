import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    id: window
    width: 500
    height: 1000
    title: qsTr("Pipe Crawler Wheels Control")

    WheelPair {
        id: front_left_wheels_controller
        visible: false
        // isFront: true

        anchors.horizontalCenter: schemeLinesFront.left
        anchors.verticalCenter: schemeLinesFront.verticalCenter
        anchors.verticalCenterOffset: schemeLinesFront.height / 3

        width: 100
        height: 100
        elementStrokeWidth: 4
    }

    WheelPair {
        id: front_up_wheels_controller
        visible: false
        // isFront: true

        anchors.horizontalCenter: schemeLinesFront.horizontalCenter
        anchors.verticalCenter: schemeLinesFront.top
        anchors.verticalCenterOffset: schemeLinesFront.height / 3

        width: 100
        height: 100
        elementStrokeWidth: 4
    }

    WheelPair {
        id: front_right_wheels_controller
        visible: false
        // isFront: true

        anchors.horizontalCenter: schemeLinesFront.right
        anchors.verticalCenter: schemeLinesFront.verticalCenter
        anchors.verticalCenterOffset: schemeLinesFront.height / 3

        width: 100
        height: 100
        elementStrokeWidth: 4
    }


    WheelPair {
        id: back_left_wheels_controller
        visible: false
        // isFront: true

        anchors.horizontalCenter: schemeLinesBack.horizontalCenter
        anchors.verticalCenter: schemeLinesBack.verticalCenter
        anchors.verticalCenterOffset: schemeLinesBack.height / 3

        width: 100
        height: 100
        elementStrokeWidth: 4
    }

    SchemeLines {
        id: schemeLinesFront
        visible: true

        width: robotBody.width * 2.5
        height: robotBody.height * 1.5

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: robotBody.top
    }

    RobotBody {
        id: robotBody
        visible: true

        width: 130
        height: 130

        anchors.centerIn: parent
        anchors.top: schemeLinesFront.bottom
        anchors.bottom: schemeLinesBack.top
    }

    SchemeLines {
        id: schemeLinesBack
        visible: true

        rotation: 180
        width: robotBody.width * 2.5
        height: robotBody.height * 1.5

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: robotBody.bottom
    }

}
