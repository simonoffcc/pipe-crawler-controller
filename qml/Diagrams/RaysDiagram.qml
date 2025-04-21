import QtQuick

import Components

/*
тут будут собраны контроллеры для всех лучей с помощью:
        - RayControl (телеметрия + слайдер)
        - RaySpinBox (спинбокс + кнопка паблиш)
        - простейшие линии схемы
*/

Item {
    id: root

    property alias controlRadius: pathControl.radiusX

    implicitWidth: 800
    implicitHeight: 800
    // implicitWidth: 430
    // implicitHeight: 910

    PathView {
        id: circlePositioning
        anchors.fill: parent
        interactive: false

        model: 3
        delegate: RayControl {
            property var angles: [120, 0, -120]
            property var pointers: [false, true, true]
            property var values: [11, 22, 33]
            // property var rayNames: [RayName.upRay, RayName.leftRay, RayName.rightRay]

            rotation: angles[index]
            isPointerOnRight: pointers[index]
            rayPositionValue: values[index]
        }

        path: Path {
            PathAngleArc {
                id: pathControl

                centerX: root.width/2
                centerY: root.height/2
                radiusX: 125
                radiusY: radiusX
                startAngle: 30
                sweepAngle: -360
            }
        }
    }

    PathView {
        id: spinBoxPositioning
        anchors.fill: parent
        interactive: false

        model: 3
        delegate: RaySpinBox {
            property var values: [11, 22, 33]

            spinBoxValue: values[index]
        }

        path: Path {
            PathAngleArc {
                id: pathSpinBox

                centerX: root.width/2
                centerY: root.height/2
                radiusX: pathControl.radiusX + 115
                radiusY: radiusX - 15
                startAngle: -5
                sweepAngle: -((startAngle * 3) + 270)
            }
        }
    }
}
