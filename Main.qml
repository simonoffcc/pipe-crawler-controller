import QtQuick 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15

import "qml/Components"
import "qml/Controls"

ApplicationWindow {
    id: root
    visible: true
    width: 900
    height: 1000
    minimumWidth: 800
    minimumHeight: 1000
    title: qsTr("Pipe Crawler Wheels Control")

    RowLayout {
        id: mainLayout

        anchors.fill: parent
        spacing: 1

        Rectangle {
            id: diagramBackground

            color: "lightgray"
            Layout.fillWidth: true
            Layout.fillHeight: true

            RobotDiagram {
                id: robotDiagram

                anchors.centerIn: parent

                width: 600
                height: 950
            }
        }

        Rectangle {
            id: selectorsBackground

            color: "lightgray"
            Layout.preferredWidth: 300
            Layout.minimumWidth: 300
            Layout.maximumWidth: 300
            Layout.fillHeight: true

            DrivingModesPanel {
                id: controlsLayout

                anchors.left: parent.left
                spacing: 2
            }
        }
    }

    menuBar: MenuBar {
        id: menuBar

        Menu {
            title: qsTr("File")

            Action { text: qsTr("Preferences") }
            MenuSeparator { }
            Action {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: qsTr("Help")
            Action { text: qsTr("About") }
        }
    }
}
