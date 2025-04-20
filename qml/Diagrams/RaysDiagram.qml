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

    width: 700
    height: 700

    Item {
        // TEMP TEMP TEMP
        id: pathContours
        anchors.fill: parent
        
        Rectangle {
            id: innerCircle
            anchors.centerIn: parent
            width: 250
            height: 250
            radius: width/2
            color: "transparent"
            border.color: "#80808080"
            border.width: 1
        }
        
        Rectangle {
            id: outerCircle
            anchors.centerIn: parent
            width: 230
            height: 230
            radius: width/2
            color: "transparent"
            border.color: "#80808080"
            border.width: 1
        }
        
        // Add visual indicator for the semi-circle
        Canvas {
            id: semiCircleIndicator
            anchors.fill: parent
            
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                
                // Draw semi-circle
                ctx.beginPath();
                ctx.strokeStyle = "#80808080";  // Semi-transparent gray
                ctx.lineWidth = 1;
                
                // Start from right (0 degrees) and go counter-clockwise to left (-180 degrees)
                ctx.arc(width/2, height/2, 250, 0, Math.PI, true);
                ctx.stroke();
            }
        }
    }

    PathView {
        id: circlePositioning
        anchors.fill: parent
        interactive: false

        model: 3
        delegate: RayControl {
            property var angles: [0, 120, -120]
            property var pointers: [true, false, true]
            property var values: [11, 22, 33]
            // property var rayNames: [RayName.upRay, RayName.leftRay, RayName.rightRay]
            
            rotation: angles[index]
            isPointerOnRight: pointers[index]
            rayPositionValue: values[index]
        }

        path: Path {
            startX: root.width/2
            startY: root.height/2 - 125

            PathAngleArc {
                centerX: root.width/2
                centerY: root.height/2
                radiusX: 125
                radiusY: 125
                startAngle: -90
                sweepAngle: 360
            }
        }
    }

    PathView {
        id: spinBoxPositioning
        anchors.fill: parent
        interactive: false

        model: 3
        delegate: RaySpinBox {
            property var values: [22, 11, 33]
            spinBoxValue: values[index]
        }


        path: Path {
            startX: root.width/2
            startY: root.height/2

            PathAngleArc {
                centerX: root.width/2
                centerY: root.height/2
                radiusX: 230
                radiusY: 230
                startAngle: 0
                sweepAngle: -270 // в теории должно быть -180, но почему то так ровнее
            }
        }
    }
}

