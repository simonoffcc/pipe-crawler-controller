import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Diagrams
import Panels

import WheelController

ApplicationWindow {
    id: root
    visible: true
    width: 1920
    height: 1080
    visibility: Window.Maximized
    title: qsTr("Pipe Crawler Wheels Control")

    RowLayout {
        id: mainLayout

        anchors.fill: parent
        anchors.margins: 4
        spacing: 4

        Rectangle {
            id: wheelPairsBackground

            Layout.preferredWidth: 750
            Layout.minimumWidth: 720
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "lightgray"

            WheelPairsDiagram {
                id: wheelPairsDiagram
                anchors.centerIn: parent
                isLocked: drivingModesPanel.isLocked
            }
        }

        Rectangle {
            id: raysBackground

            Layout.preferredWidth: 750
            Layout.minimumWidth: 720
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "lightgray"

            RaysDiagram {
                id: raysDiagram
                anchors.centerIn: parent
            }

        }

        ColumnLayout {
            id: controlPanel

            Layout.preferredWidth: 350
            Layout.minimumWidth: 350
            Layout.maximumWidth: 400
            Layout.fillHeight: true
            spacing: 4

            DrivingModesPanel {
                id: drivingModesPanel

                Layout.minimumHeight: implicitHeight
                Layout.preferredHeight: implicitHeight
                Layout.fillWidth: true
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
            title: qsTr("Program")
            Action {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
    }
}
