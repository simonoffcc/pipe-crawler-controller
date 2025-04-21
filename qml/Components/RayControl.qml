import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Controls.Basic

import rayName

Item {
    id: root

    // property int rayName: RayName.Unknown
    property int backgroundWidth: 100
    property int backgroundHeight: 125
    property int backgroundBorderWidth : 2
    property int commonRadius: 1
    property bool isPointerOnRight: true

    property int rayPositionValue: 55 // потом будет проперти, который будет передавать значение с телеметрии
    readonly property double maxRayPositionValue: 220

    implicitWidth: rayIndicator.width
    implicitHeight: rayIndicator.height

    Item {
        id: rayIndicator

        implicitWidth: root.backgroundWidth
        implicitHeight: root.backgroundHeight
        anchors.left: root.isPointerOnRight ? parent.left : undefined
        anchors.right: !root.isPointerOnRight ? parent.right : undefined

        Rectangle {
            id: indicatorBackground

            anchors.fill: parent
            color: "#bdbebf"
            border.color: "#97999b"
            border.width: root.backgroundBorderWidth
            radius: root.commonRadius

            Rectangle {
                id: indicatorBackgroundNotUsed

                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: root.backgroundBorderWidth
                }

                height: root.rayPositionValue / root.maxRayPositionValue * parent.height
                radius: root.commonRadius
                color: "#008080"
            }
        }
    }

    Slider {
        id: raySlider

        implicitWidth: handle.width
        implicitHeight: root.backgroundHeight

        transform: Scale {
            xScale: root.isPointerOnRight ? 1 : -1
        }
        anchors.left: root.isPointerOnRight ? parent.left : parent.right

        topPadding: pointer.height / 2
        bottomPadding: pointer.height / 2
        orientation: Qt.Vertical

        from: 0
        to: root.maxRayPositionValue
        stepSize: 5

        background: Rectangle {
            id: slideBackground

            x: root.backgroundWidth / 2 - slideBackground.width / 2
            y: root.backgroundBorderWidth
            width: root.backgroundWidth - 2 * root.backgroundBorderWidth
            height: root.backgroundHeight - 2 * root.backgroundBorderWidth
            radius: root.commonRadius
            color: "#008080"
            opacity: 0.5

            Rectangle {
                id: slideBackgroundNotUsed

                width: slideBackground.width
                height: raySlider.visualPosition * slideBackground.height
                radius: root.commonRadius
                color: "#bdbebf"
            }
        }

        handle: Rectangle {
            id: handle

            y: -raySlider.bottomPadding + raySlider.visualPosition * root.backgroundHeight
            width: pointer.width + root.backgroundWidth
            height: pointer.height

            color: "transparent"

            Shape {
                id: pointer

                anchors.right: parent.right

                width: 15
                height: width

                ShapePath {
                    id: triangle

                    fillColor: "#f0f0f0"
                    strokeWidth: 1
                    strokeColor: "#97999b"

                    startX: pointer.width; startY: pointer.height
                    PathLine { x: 0; y: pointer.height / 2 }
                    PathLine { x: pointer.width; y:  0}
                    PathLine { x: pointer.width; y:  pointer.height}
                }
            }
        }
    }

    Rectangle {
        id: telemetryText

        rotation: -root.rotation

        anchors.centerIn: rayIndicator

        implicitWidth: text.width * 1.5
        implicitHeight: text.height * 1.5

        radius: 10
        color: "white"
        border.color: "#97999b"

        Text {
            id: text

            anchors.centerIn: parent
            text: root.rayPositionValue + qsTr(" mm")
            font.pixelSize: 14
            color: "black"
        }
    }
}
