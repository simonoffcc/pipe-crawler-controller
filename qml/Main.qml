import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window

import WheelController
import Components
import Controls

ApplicationWindow {
    id: root
    visible: true
    width: 900
    height: 1000
    minimumWidth: diagramBackground.Layout.minimumWidth + controlsPanel.Layout.minimumWidth + mainLayout.spacing + mainLayout.anchors.margins * 2
    minimumHeight: 1000
    flags: Qt.Window
    visibility: {
        if (Qt.platform.os === "linux")
            return Window.Maximized
        return Window.AutomaticVisibility
    }
    title: qsTr("Pipe Crawler Wheels Control")

    RowLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 4
        spacing: 4

        Rectangle {
            id: diagramBackground
            color: "lightgray"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 430
            Layout.preferredWidth: 600

            RobotDiagram {
                id: robotDiagram
                anchors.centerIn: parent
                isLocked: controlsLayout.isLocked
                width: Math.min(parent.width - 40, 600)
                height: Math.min(parent.height - 40, 950)
            }
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
