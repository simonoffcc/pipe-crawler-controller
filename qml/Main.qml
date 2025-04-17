import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Controls

import WheelController

ApplicationWindow {
    id: root
    visible: true
    // width: 900
    // height: 1000
    minimumWidth: diagramBackground.Layout.minimumWidth + controlsPanel.Layout.minimumWidth + mainLayout.spacing + mainLayout.anchors.margins * 2
    minimumHeight: 1000
    visibility: Window.Maximized
    title: qsTr("Pipe Crawler Wheels Control")

    RowLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 4
        spacing: 4

        Rectangle {
            id: diagramBackground

            visible: false

            color: "lightgray"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 720
            Layout.preferredWidth: 750

            RobotDiagram {
                id: robotDiagram

                anchors.centerIn: parent
                isLocked: controlsLayout.isLocked
            }
        }

        Rectangle {
            id: robotRaysDiagram

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 500
            Layout.preferredWidth: 500
            color: "lightgray"

            RayControl {
                id: rayIndicator

                anchors.centerIn: parent
            }

            // RaySpinBox {
            //     id: raySpinBox

            //     anchors {
            //         bottom: rayIndicator.top
            //         bottomMargin: 10
            //     }
            // }

        }

        ColumnLayout {
            id: controlsPanel

            Layout.preferredWidth: 350
            Layout.minimumWidth: 350
            Layout.maximumWidth: 400
            Layout.fillHeight: true
            spacing: 4

            DrivingModesPanel {
                id: controlsLayout

                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                Layout.preferredHeight: implicitHeight
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
