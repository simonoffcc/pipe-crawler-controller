import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

import Diagrams
import Panels

ApplicationWindow {
    id: root
    visible: true
    width: 1920
    height: 1080
    visibility: Window.Maximized
    title: qsTr("Pipe Crawler Controller")
    color: "#F5F5F5"

    property bool isLandscape: mainLayout.width > mainLayout.height

    GridLayout {
        id: mainLayout

        anchors.fill: parent
        columns: isLandscape ? 3 : 2
        rows: isLandscape ? 1 : 2

        Rectangle {
            id: wheelPairsBackground

            Layout.row: 0
            Layout.column: 0
            Layout.preferredWidth: wheelPairsDiagram.width + 10
            Layout.minimumWidth: wheelPairsDiagram.width
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#EEEEEE"

            Label {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.leftMargin: 10
                text: qsTr("Wheel Pairs Diagram")
                font.pointSize: 12
                color: "#212121"
            }

            WheelPairsDiagram {
                id: wheelPairsDiagram
                anchors.centerIn: parent
                isLocked: drivingModesPanel.isLocked
            }
        }

        Rectangle {
            id: raysBackground

            Layout.row: root.isLandscape ? 0 : 1
            Layout.column: root.isLandscape ? 1 : 0
            Layout.preferredWidth: raysDiagram.width + 10
            Layout.minimumWidth: raysDiagram.width
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#EEEEEE"

            Label {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.leftMargin: 10
                text: qsTr("Rays Diagram")
                font.pointSize: 12
                color: "#212121"
            }

            RaysDiagram {
                id: raysDiagram
                anchors.centerIn: parent
                controlsVisible: raysControlPanel.controlsVisible
            }
        }

        ColumnLayout {
            id: controlPanel

            Layout.row: 0
            Layout.column: root.isLandscape ? 2 : 1
            Layout.rowSpan: isLandscape ? 1 : 2
            Layout.preferredWidth: 350
            Layout.minimumWidth: 350
            Layout.maximumWidth: 350
            Layout.fillHeight: true
            spacing: 4

            DrivingModesPanel {
                id: drivingModesPanel

                Layout.minimumHeight: implicitHeight
                Layout.preferredHeight: implicitHeight
                Layout.fillWidth: true
            }

            RaysControlPanel {
                id: raysControlPanel

                Layout.minimumHeight: height
                Layout.preferredHeight: height
                Layout.fillWidth: true
            }

            LogPanel {
                id: logPanel

                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    Shortcut {
        sequences: ["Ctrl+Q"]
        onActivated: Qt.quit()
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
