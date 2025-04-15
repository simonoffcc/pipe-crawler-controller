import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Item {
    id: root
    height: 150
    width: slideBackground.width + handleRect.width

    property bool readOnly: false
    signal valueSubmitted(real value)

    Slider {
        id: slider
        anchors.fill: parent
        orientation: Qt.Vertical
        enabled: !root.readOnly

        from: 0
        value: 55
        to: 220
        stepSize: 5

        background: Rectangle {
            id: slideBackground
            x: slider.leftPadding + slider.availableWidth / 2 - width / 2
            y: slider.topPadding
            width: 8
            height: slider.availableHeight
            radius: 4
            color: root.readOnly ? "#808080" : "#008080"

            Rectangle {
                width: parent.width
                height: slider.visualPosition * parent.height
                color: root.readOnly ? "#a0a0a0" : "#bdbebf"
                radius: 4
            }
        }

        handle: Rectangle {
            id: handleRect
            x: slider.leftPadding + slider.availableWidth / 2 - width / 2
            y: slider.topPadding + slider.visualPosition * (slider.availableHeight - height)
            width: 40
            height: 24
            color: root.readOnly ? "#e0e0e0" : "#f0f0f0"
            border.color: "#bdbebf"
            border.width: 1
            radius: 4

            TextField {
                id: inputField
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                color: "#2c3e50"
                text: Math.round(slider.value).toString()
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                font.pixelSize: 12
                font.bold: true
                readOnly: root.readOnly
                background: Rectangle {
                    color: "transparent"
                }

                validator: IntValidator {
                    bottom: 0
                    top: 220
                }

                onTextChanged: {
                    if (text.length > 0 && parseInt(text) >= 0 && parseInt(text) <= 220) {
                        slider.value = parseInt(text)
                    }
                }

                onFocusChanged: {
                    if (!focus && (text === "" || isNaN(parseInt(text)))) {
                        text = Math.round(slider.value).toString()
                    }
                }

                Keys.onReturnPressed: {
                    if (!root.readOnly && text.length > 0) {
                        root.valueSubmitted(parseFloat(text))
                        text = ""
                    }
                }

                Keys.onEnterPressed: {
                    if (!root.readOnly && text.length > 0) {
                        root.valueSubmitted(parseFloat(text))
                        text = ""
                    }
                }
            }
        }

        onValueChanged: {
            if (!inputField.focus) {
                inputField.text = Math.round(value).toString()
            }
        }
    }
}
