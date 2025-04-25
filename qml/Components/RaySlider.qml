import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Controls.Basic

import rayName

Item {
    id: root

    property int rayName: RayName.Unknown
    property int rayPositionValue: 0
    property alias currentSliderValue: raySlider.value

    property bool pointerOnRight: true
    property alias sliderVisible: raySlider.visible
    readonly property double maxRayPositionValue: 220

    property int backgroundWidth: 100
    property int backgroundHeight: 125
    property int backgroundBorderWidth: 2
    property int commonRadius: 1

    implicitWidth: rayIndicator.width
    implicitHeight: rayIndicator.height

    signal sliderValueChanged(real value)

    ProgressBar {
        id: rayIndicator

        value: {
            if (root.rayPositionValue < 0) return 0;
            if (root.rayPositionValue > root.maxRayPositionValue) return root.maxRayPositionValue;
            return root.rayPositionValue;
        }
        from: 0
        to: root.maxRayPositionValue
        padding: root.backgroundBorderWidth

        background: Rectangle {
            id: indicatorBackground
            implicitWidth: root.backgroundWidth
            implicitHeight: root.backgroundHeight
            border.color: "#97999b"
            border.width: root.backgroundBorderWidth
            color: "#bdbebf"
            radius: root.commonRadius
        }

        contentItem: Item {
            id: indicatorInUse

            rotation: 180
            implicitWidth: root.backgroundWidth - (2 * root.backgroundBorderWidth)
            implicitHeight: root.backgroundHeight - (2 * root.backgroundBorderWidth)
            x: root.backgroundBorderWidth
            y: root.backgroundBorderWidth

            Rectangle {
                width: parent.width
                height: rayIndicator.visualPosition * parent.height
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
            xScale: root.pointerOnRight ? 1 : -1
        }
        anchors.left: root.pointerOnRight ? parent.left : parent.right

        topPadding: pointer.height / 2
        bottomPadding: pointer.height / 2
        orientation: Qt.Vertical

        from: 0
        to: root.maxRayPositionValue
        stepSize: 5

        onMoved: {
            root.sliderValueChanged(value)
        }

        background: Rectangle {
            id: slideBackground

            x: root.backgroundWidth / 2 - slideBackground.width / 2
            y: root.backgroundBorderWidth
            width: root.backgroundWidth - (2 * root.backgroundBorderWidth)
            height: root.backgroundHeight - (2 * root.backgroundBorderWidth)
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

            y: root.backgroundBorderWidth - raySlider.bottomPadding + raySlider.visualPosition * (root.backgroundHeight - 2 * root.backgroundBorderWidth)
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
