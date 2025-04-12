import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import WheelController

Rectangle {
    id: root
    color: "lightgray"
    property alias model: logView.model

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                id: controlsTitle
                Layout.fillWidth: true
                font.pixelSize: 14
                font.bold: true
                color: "black"
                text: qsTr("Log Messages")
            }

            Button {
                text: qsTr("Clear")
                onClicked: WheelController.clearLogMessages()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"
            radius: 4
            border.color: "#cccccc"
            border.width: 1

            ListView {
                id: logView
                anchors.fill: parent
                anchors.margins: 4
                clip: true
                verticalLayoutDirection: ListView.BottomToTop
                spacing: 1

                delegate: Rectangle {
                    width: ListView.view.width
                    height: messageText.contentHeight + 16
                    color: index % 2 ? "#f8f8f8" : "white"

                    Text {
                        id: messageText
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: 8
                        }
                        text: modelData
                        wrapMode: Text.WordWrap
                        font.pixelSize: 12
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    active: true
                }
            }
        }
    }
} 
