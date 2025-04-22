import QtQuick
import QtQuick.Shapes

import Components
import rayName

Item {
    id: root

    property int controlsArcRadius: 125
    property int spinBoxesArcRadius: controlsArcRadius + 115

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
            height: root.controlsArcRadius
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
                radiusX: root.controlsArcRadius / 2
                radiusY: root.controlsArcRadius / 2
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
            property var rayNames: [RayName.FrontLeft, RayName.FrontUp, RayName.FrontRight]
            property var angles: [-120, 0, 120]
            property var pointerOnRight: [true, true, false]
            property var telemetryValues: [11, 22, 33] // телеметрия
            // property var currentSliderValues: []

            rayName: rayNames[index]
            rotation: angles[index]
            isPointerOnRight: pointerOnRight[index]
            rayPositionValue: telemetryValues[index]
        }

        path: Path {
            PathAngleArc {
                id: pathControl

                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root.controlsArcRadius
                radiusY: root.controlsArcRadius
                startAngle: 150
                sweepAngle: 360
            }
        }
    }

    PathView {
        id: spinBoxesPositioning
        anchors.fill: parent
        interactive: false

        model: 3
        delegate: RaySpinBox {
            property var rayNames: [RayName.FrontLeft, RayName.FrontUp, RayName.FrontRight]
            property var values: [11, 22, 33]
            // property var currentSliderPositions: []

            rayName: rayNames[index]
            spinBoxValue: values[index]
        }

        path: Path {
            PathPercent { value: 1/3 }
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root.spinBoxesArcRadius
                radiusY: root.spinBoxesArcRadius - 15
                startAngle: 180
                sweepAngle: 360
            }
        }
    }
}
