import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts

import Controllers

import RobotController
import RayJointName

Column {
    id: root

    property bool controlsVisible: true

    RaysController {
        id: frontRaysController
        title: qsTr("Front")
        controlsVisible: root.controlsVisible
        rayNames: [RayJointName.FrontLeft, RayJointName.FrontUp, RayJointName.FrontRight]
    }

    RaysController {
        id: backRaysController
        title: qsTr("Back")
        controlsVisible: root.controlsVisible
        rayNames: [RayJointName.BackLeft, RayJointName.BackUp, RayJointName.BackRight]
    }
}
