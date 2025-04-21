import QtQuick
import QtQuick.Shapes

import Components
import rayName

Item {
    id: root

    property int controlRadius: 125

    implicitWidth: 800
    implicitHeight: 800
    // implicitWidth: 430
    // implicitHeight: 910

    PathView {
        id: schemeLinesPositioning

        anchors.fill: parent
        interactive: false

        model: 3
        delegate: Rectangle {
            width: 2
            height: root.controlRadius
            color: "black"
            opacity: 0.3
            antialiasing: true

            property var angles: [120, 0, -120]
            rotation: angles[index]
        }

        path: Path {
            PathAngleArc {
                id: pathSchemeLines

                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root.controlRadius / 2
                radiusY: root.controlRadius / 2
                startAngle: 30
                sweepAngle: -360
            }
        }
    }

    PathView {

        id: controlsPositioning
        anchors.fill: parent
        interactive: false

        model: 3
        delegate: RayControl {
            property var rayNames: [RayName.FrontRight, RayName.FrontUp, RayName.FrontLeft]
            property var angles: [120, 0, -120]
            property var pointers: [false, true, true]
            property var values: [11, 22, 33]

            rayName: rayNames[index]
            rotation: angles[index]
            isPointerOnRight: pointers[index]
            rayPositionValue: values[index]
        }

        path: Path {
            PathAngleArc {
                id: pathControl

                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root.controlRadius
                radiusY: root.controlRadius
                startAngle: 30
                sweepAngle: -360
            }
        }
    }

    PathView {
        id: spinBoxesPositioning
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

                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root.controlRadius + 115
                radiusY: radiusX - 15
                startAngle: -5
                sweepAngle: -((startAngle * 3) + 270)
            }
        }
    }
}
