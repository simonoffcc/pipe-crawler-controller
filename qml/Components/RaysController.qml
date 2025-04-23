import QtQuick
import QtQuick.Shapes

import rayName

Item {
    id: root

    property var rayNames: [RayName.Unknown, RayName.Unknown, RayName.Unknown]
    property var rayControllerValues: [0, 0, 0]
    property var telemetryValues: [0, 0, 0]
    property bool controlsVisible: true

    property int controlsArcRadius: 125
    property int spinBoxesArcRadius: controlsArcRadius + 100

    implicitWidth: 670
    implicitHeight: 450

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
        id: slidersPositioning
        anchors.fill: parent
        interactive: false

        model: 3
        delegate: RaySlider {
            property var angles: [-120, 0, 120]
            property var pointerOnRightValues: [true, true, false]

            sliderVisible: root.controlsVisible
            rayName: root.rayNames[index]
            rotation: angles[index]
            pointerOnRight: pointerOnRightValues[index]
            rayPositionValue: root.telemetryValues[index]

            currentSliderValue: root.rayControllerValues[index]

            onSliderValueChanged: function(value) {
                updateRayValue(index, value);
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
            visible: root.controlsVisible
            rayName: root.rayNames[index]

            currentSpinBoxValue: root.rayControllerValues[index]

            onSpinBoxValueChanged: function(value) {
                updateRayValue(index, value);
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

    function updateRayValue(index, value) {
        var newValues = rayControllerValues.slice();
        newValues[index] = value;
        rayControllerValues = newValues;
    }
}
