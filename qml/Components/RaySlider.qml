import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Item {
    id: root
    height: 150
    width: Math.max(slideBackground.width, handleRect.width)

    property int globalRadius: 1

    Slider {
        id: slider
        anchors.fill: parent
        orientation: Qt.Vertical

        value: 55
        from: 0
        to: 220
        stepSize: 5

        background: Rectangle {
            id: slideBackground
            x: slider.leftPadding + slider.availableWidth / 2 - width / 2
            y: slider.topPadding
            width: 15
            height: slider.availableHeight
            radius: root.globalRadius
            color: "#008080"

            Rectangle {
                id: slideBackgroundNotUsed
                width: parent.width
                height: slider.visualPosition * parent.height
                radius: root.globalRadius
                color: "#bdbebf"
            }
        }

        handle: Rectangle {
            id: handleRect
            x: slider.leftPadding + slider.availableWidth / 2 - width / 2
            y: slider.topPadding + slider.visualPosition * (slider.availableHeight - height)
            width: 40
            height: 15
            color: "#f0f0f0"
            border.color: "#bdbebf"
            border.width: 1
            radius: root.globalRadius
        }
    }
}
