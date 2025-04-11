import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import WheelController
import Components
import Controls

ApplicationWindow {
    id: root
    visible: true
    width: 900
    height: 1000
    minimumWidth: 800
    minimumHeight: 1000
    visibility: Window.Maximized
    title: qsTr("Pipe Crawler Wheels Control")

    RowLayout {
        id: mainLayout

        anchors.fill: parent
        spacing: 1

        Rectangle {
            id: diagramBackground

            color: "lightgray"

            Layout.preferredWidth: robotDiagram.width + 100
            Layout.minimumWidth: robotDiagram.width

            Layout.fillWidth: true
            Layout.fillHeight: true

            RobotDiagram {
                id: robotDiagram

                anchors.centerIn: parent
                isLocked: controlsLayout.isLocked

                width: 600
                height: 950
            }
        }

        ColumnLayout {
            Layout.preferredWidth: 400
            Layout.minimumWidth: 400
            Layout.maximumWidth: 400
            Layout.fillHeight: true
            spacing: 4

            Rectangle {
                id: selectorsBackground

                color: "lightgray"
                Layout.fillWidth: true
                Layout.preferredHeight: controlsLayout.height

                DrivingModesPanel {
                    id: controlsLayout
                    anchors.left: parent.left
                    spacing: 2
                }
            }

            LogPanel {
                id: logPanel

                Layout.fillWidth: true
                Layout.fillHeight: true
                model: WheelController.logMessages
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
