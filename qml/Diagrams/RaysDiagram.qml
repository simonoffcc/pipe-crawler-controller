import QtQuick
import QtQuick.Shapes

import Components
import rayName

Column {
    id: root

    RaysController {
        id: frontRaysController

        property var rayNames: [RayName.FrontLeft, RayName.FrontUp, RayName.FrontRight]
    }

    RaysController {
        id: backRaysController

        property var rayNames: [RayName.BackLeft, RayName.BackUp, RayName.BackRight]
    }
}
