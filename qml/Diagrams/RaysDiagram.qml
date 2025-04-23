import QtQuick
import QtQuick.Shapes

import Components
import rayName

Item {
    id: root

    property int controlsArcRadius: 125
    property int spinBoxesArcRadius: controlsArcRadius + 100

    implicitWidth: 670
    implicitHeight: 450

    property real value1: 0
    property real value2: 0
    property real value3: 0

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
                centerY: root.height / 1.7
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
            property var telemetryValues: [11, 22, 33]

            rayName: rayNames[index]
            rotation: angles[index]
            isPointerOnRight: pointerOnRight[index]
            rayPositionValue: telemetryValues[index]

            currentSliderValue: {
                switch(index) {
                    case 0: return root.value1;
                    case 1: return root.value2;
                    case 2: return root.value3;
                }
            }

            onSliderValueChanged: function(value) {

                switch(index) {
                    case 0: root.value1 = value; break;
                    case 1: root.value2 = value; break;
                    case 2: root.value3 = value; break;
                }
            }
        }

        path: Path {
            PathAngleArc {
                id: pathControl

                centerX: root.width / 2
                centerY: root.height / 1.7
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

            rayName: rayNames[index]

            currentSpinBoxValue: {
                switch(index) {
                    case 0: return root.value1;
                    case 1: return root.value2;
                    case 2: return root.value3;
                }
            }

            onSpinBoxValueChanged: function(value) {
                switch(index) {
                    case 0: root.value1 = value; break;
                    case 1: root.value2 = value; break;
                    case 2: root.value3 = value; break;
                }
            }
        }

        path: Path {
            PathPercent { value: 1 / 3 }
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 1.8
                radiusX: root.spinBoxesArcRadius
                radiusY: root.spinBoxesArcRadius - 15
                startAngle: 180
                sweepAngle: 360
            }
        }
    }
}
