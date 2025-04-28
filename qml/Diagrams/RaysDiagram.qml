import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts

import Controllers

import RobotController
import rayName

Column {
    id: root

    property bool controlsVisible: true

    RaysController {
        id: frontRaysController
        title: qsTr("Front")
        controlsVisible: root.controlsVisible
        rayNames: [RayName.FrontLeft, RayName.FrontUp, RayName.FrontRight]
    }

    RaysController {
        id: backRaysController
        title: qsTr("Back")
        controlsVisible: root.controlsVisible
        rayNames: [RayName.BackLeft, RayName.BackUp, RayName.BackRight]
    }
}
