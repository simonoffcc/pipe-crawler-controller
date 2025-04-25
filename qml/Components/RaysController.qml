import QtQuick
import QtQuick.Shapes

import RobotController
import rayName

Item {
    id: root

    property var rayNames: [RayName.Unknown, RayName.Unknown, RayName.Unknown]
    property var rayControlValues: [0, 0, 0]
    property var rayTelemetryValues: [0, 0, 0]
    property bool controlsVisible: true
    property alias title: directionHint.hintText

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
            color: "#a6a6a6"
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

    DirectionHint {
        id: directionHint
        x: root.width / 2 - width / 2
        y: root.height / 1.7 - height / 2
        hintText: qsTr("undefined")
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
            rayPositionValue: root.rayTelemetryValues[index]

            currentSliderValue: root.rayControlValues[index]

            onSliderValueChanged: function(value) {
                syncControlsValues(index, value);
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

            currentSpinBoxValue: root.rayControlValues[index]

            onSpinBoxValueChanged: function(value) {
                syncControlsValues(index, value);
            }

            onPublishButtonClicked: {
                RobotController.publishRayPosition(
                    millimetersToMeters(root.rayControlValues[index]), root.rayNames[index]
                );
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

    Connections {
        target: RobotController

        function onControllersChanged() {
            var controllers = RobotController.controllers;
            root.updateTelemetryValues(controllers);
        }
    }

    function syncControlsValues(index, value) {
        var newValues = rayControlValues.slice();
        newValues[index] = value;
        rayControlValues = newValues;
    }

    function metersToMillimeters(meters) {
        return Math.round(meters * 1000);
    }

    function millimetersToMeters(mm) {
        return mm / 1000.0;
    }

    function updateTelemetryValues(controllers) {
        var newValues = rayTelemetryValues.slice();
        for (var i = 0; i < rayNames.length; i++) {
            for (var j = 0; j < controllers.length; j++) {
                if (controllers[j].rayName === rayNames[i]) {
                    let position = parseFloat(controllers[j].rayPosition);
                    if (!isNaN(position) && position >= 0 && position <= 0.22) {
                        newValues[i] = metersToMillimeters(position);
                    } else {
                        newValues[i] = 0;
                    }
                }
            }
        }
        rayTelemetryValues = newValues;
    }

    function onPublishButtonClicked() {
        RobotController.publishRayPosition(millimetersToMeters(value), root.rayNames[index]);
    }
}
