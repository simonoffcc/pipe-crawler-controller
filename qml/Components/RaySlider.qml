import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Item {
    id: root
    height: 150
    width: Math.max(slideBackground.width, handleRect.width)

    property bool blocked: false
    property bool showPublishButton: !blocked
    property real initialValue: 55
    property bool valueChanged: false
    property bool publishButtonOnRight: false
    signal valueSubmitted(real value)

    Slider {
        id: slider
        anchors.fill: parent
        orientation: Qt.Vertical

        from: 0
        value: root.initialValue
        to: 220
        stepSize: 5

        background: Rectangle {
            id: slideBackground
            x: slider.leftPadding + slider.availableWidth / 2 - width / 2
            y: slider.topPadding
            width: 20
            height: slider.availableHeight
            radius: 4
            color: "#008080"

            Rectangle {
                width: parent.width
                height: slider.visualPosition * parent.height
                color: "#bdbebf"
                radius: 4
            }
        }

        handle: Item {
            x: slider.leftPadding + slider.availableWidth / 2 - (root.publishButtonOnRight ? 0 : handleRect.width)
            y: slider.topPadding + slider.visualPosition * (slider.availableHeight - handleRect.height)
            width: handleRect.width + (showPublishButton ? publishButton.width : 0)
            height: handleRect.height

            Rectangle {
                id: handleRect
                width: 40
                height: 24
                x: root.publishButtonOnRight ? -width : 0
                color: "#f0f0f0"
                border.color: "#bdbebf"
                border.width: 1
                radius: 4

                TextField {
                    id: inputField
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    color: "#2c3e50"
                    text: root.blocked ? Math.round(slider.value).toString() : (root.valueChanged ? Math.round(slider.value).toString() : "")
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    font.pixelSize: 12
                    font.bold: true
                    readOnly: root.blocked
                    background: Rectangle {
                        color: "transparent"
                    }

                    validator: IntValidator {
                        bottom: 0
                        top: 220
                    }

                    onTextChanged: {
                        if (!root.blocked && text.length > 0 && parseInt(text) >= 0 && parseInt(text) <= 220) {
                            slider.value = parseInt(text)
                            root.valueChanged = true
                        }
                    }

                    onFocusChanged: {
                        if (!focus && (text === "" || isNaN(parseInt(text)))) {
                            text = root.blocked ? Math.round(slider.value).toString() : (root.valueChanged ? Math.round(slider.value).toString() : "")
                        }
                    }

                    Keys.onReturnPressed: {
                        if (!root.blocked && text.length > 0) {
                            root.valueSubmitted(parseInt(text))
                            root.valueChanged = false
                            text = ""
                        }
                    }

                    Keys.onEnterPressed: {
                        if (!root.blocked && text.length > 0) {
                            root.valueSubmitted(parseInt(text))
                            root.valueChanged = false
                            text = ""
                        }
                    }
                }
            }

            Button {
                id: publishButton
                visible: root.showPublishButton && root.valueChanged
                hoverEnabled: true

                width: 60
                height: handleRect.height
                text: qsTr("Publish")

                background: Rectangle {
                    property color normalColor: "#2c3e50"
                    property color hoveredColor: "#333333"
                    property color pressedColor: "#666666"

                    border.color: "#bdbebf"
                    radius: 7
                    color: publishButton.pressed ? pressedColor :
                           publishButton.hovered ? hoveredColor : normalColor
                }

                contentItem: Text {
                    anchors.fill: parent

                    text: publishButton.text
                    font.pixelSize: 14
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                anchors {
                    left: root.publishButtonOnRight ? handleRect.right : undefined
                    right: root.publishButtonOnRight ? undefined : handleRect.left
                    leftMargin: root.publishButtonOnRight ? 5 : 0
                    rightMargin: root.publishButtonOnRight ? 0 : 5
                    verticalCenter: handleRect.verticalCenter
                }

                onClicked: {
                    if (!root.blocked && inputField.text.length > 0) {
                        root.valueSubmitted(parseInt(inputField.text))
                        root.valueChanged = false
                        inputField.text = ""
                    }
                }
            }
        }

        onValueChanged: {
            if (!inputField.focus && !root.blocked) {
                root.valueChanged = true
                inputField.text = Math.round(value).toString()
            }
        }

        Component.onCompleted: {
            root.valueChanged = false
            if (!root.blocked) {
                inputField.text = ""
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.blocked
        preventStealing: true
        hoverEnabled: true

        onPressed: {}
        onReleased: {}
        onClicked: {}
        onDoubleClicked: {}
        onPositionChanged: {}
        onPressAndHold: {}
        onWheel: {}

        onFocusChanged: {}
    }
}
