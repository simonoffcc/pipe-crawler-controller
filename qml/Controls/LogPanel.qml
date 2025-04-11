import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    color: "lightgray"

    property alias model: logView.model

    ColumnLayout {
        anchors.fill: parent
        spacing: 4

        Text {
            id: controlsTitle

            Layout.leftMargin: 10
            Layout.topMargin: 10
            Layout.rightMargin: 10

            font.pixelSize: 16
            color: "black"
            text: qsTr("Log Messages")
        }

        ListView {
            id: logView

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 4
            clip: true
            verticalLayoutDirection: ListView.BottomToTop

            delegate: Rectangle {
                width: ListView.view.width
                height: messageText.height + 8
                color: index % 2 ? "#f0f0f0" : "white"

                Text {
                    id: messageText

                    text: modelData
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 4
                    wrapMode: Text.WordWrap
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }
    }
} 
