import QtQuick 2.15
import QtQuick.Controls 2.15

import "qml/Components"

ApplicationWindow {
    id: root
    visible: true
    width: 500
    height: 1000
    title: qsTr("Pipe Crawler Wheels Control")

    RobotDiagram {
        id: robotDiagram

        anchors.fill: parent
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
