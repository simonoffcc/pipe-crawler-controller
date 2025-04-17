import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Controls.Basic

Item {
    id: root

    property int backgroundWidth: 100
    property int backgroundHeight: backgroundWidth * 1.5
    property bool borderAllOver: false
    property int backgroundBorderWidth : 2
    property int commonRadius: 1

    property alias pointerWidth: handlePointer.width
    property alias pointerHeight: handlePointer.height
    property alias pointerBorderWidth: triangle.strokeWidth

    readonly property int positionValue: 120 // потом будет проперти, который будет передавать значение с телеметрии
    readonly property double maxPositionValue: 220

    width: Math.max(rayIndicator.width, raySlider.width)
    height: Math.max(rayIndicator.height, raySlider.height)

    Item {
        id: rayIndicator

        width: root.backgroundWidth
        height: root.backgroundHeight

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
                    margins: borderAllOver ? root.backgroundBorderWidth : 0
                }

                height: root.positionValue / root.maxPositionValue * root.height
                radius: root.commonRadius
                color: "#008080"
            }
        }
    }

    Slider {
        id: raySlider

        width: root.backgroundWidth
        height: root.backgroundHeight

        orientation: Qt.Vertical

        value: 55
        from: 0
        to: 220
        stepSize: 5

        background: Rectangle {
            id: slideBackground

            x: root.backgroundWidth / 2 - width / 2
            y: raySlider.topPadding - raySlider.bottomPadding

            width: root.backgroundWidth
            height: root.backgroundHeight
            radius: root.commonRadius
            color: "#008080"
            opacity: 0.5

            Rectangle {
                id: slideBackgroundNotUsed

                width: parent.width
                height: raySlider.visualPosition * parent.height
                radius: root.commonRadius
                color: "#bdbebf"
            }
        }

        handle: Shape {
            id: handlePointer

            x: root.backgroundWidth + (handlePointer.width / 2)
            y: raySlider.visualPosition * (raySlider.availableHeight - handlePointer.height)
            width: 20
            height: 15

            ShapePath {
                id: triangle

                fillColor: "#f0f0f0"
                strokeWidth: 1
                strokeColor: "#97999b"

                startX: handlePointer.width; startY: handlePointer.height
                PathLine { x: 0; y: handlePointer.height / 2 }
                PathLine { x: handlePointer.width; y:  0}
                PathLine { x: handlePointer.width; y:  handlePointer.height}
            }
        }
    }
}
