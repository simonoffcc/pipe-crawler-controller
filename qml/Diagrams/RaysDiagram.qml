import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts

import Components
import rayName
import RobotController

Column {
    id: root

    property bool controlsVisible: true

    RaysController {
        id: frontRaysController
        title: "Front"
        controlsVisible: root.controlsVisible
        rayNames: [RayName.FrontLeft, RayName.FrontUp, RayName.FrontRight]
    }

    RaysController {
        id: backRaysController
        title: "Back"
        controlsVisible: root.controlsVisible
        rayNames: [RayName.BackLeft, RayName.BackUp, RayName.BackRight]
    }
}
