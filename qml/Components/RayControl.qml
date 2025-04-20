import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Controls.Basic

Item {
    id: root

    // property int rayName: RayName.Unknown
    property int backgroundWidth: 100
    property int backgroundHeight: backgroundWidth * 1.5
    property int backgroundBorderWidth : 2
    property int commonRadius: 1
    property bool isPointerOnRight: true

    property alias pointerWidth: pointer.width
    property alias pointerHeight: pointer.height
    property alias pointerBorderWidth: triangle.strokeWidth

    property int rayPositionValue: 55 // потом будет проперти, который будет передавать значение с телеметрии
    readonly property double maxRayPositionValue: 220

    implicitWidth: raySlider.width
    implicitHeight: raySlider.height

    Item {
        id: rayIndicator

        implicitWidth: root.backgroundWidth
        implicitHeight: root.backgroundHeight

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

        Rectangle {
            id: telemetryText

            rotation: -root.rotation

            anchors.centerIn: slideBackground
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

        handle: Rectangle {
            id: handle

            x: root.isPointerOnRight ? 0 : -pointer.width
            y: -raySlider.bottomPadding + raySlider.visualPosition * root.backgroundHeight
            width: pointer.width + root.backgroundWidth
            height: pointer.height

            color: "black"
            opacity: 0.5

            Shape {
                id: pointer

                x: root.isPointerOnRight ? root.backgroundWidth : 0
                rotation: root.isPointerOnRight ? 0 : 180

                width: 20
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
}
