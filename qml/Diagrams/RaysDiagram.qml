import QtQuick
import QtQuick.Shapes

import Components
import rayName

Column {
    id: root

    property bool controlsVisible: true

    RaysController {
        id: frontRaysController

        controlsVisible: root.controlsVisible
        property var rayNames: [RayName.FrontLeft, RayName.FrontUp, RayName.FrontRight]
    }

    RaysController {
        id: backRaysController

        controlsVisible: root.controlsVisible
        property var rayNames: [RayName.BackLeft, RayName.BackUp, RayName.BackRight]
    }
}
