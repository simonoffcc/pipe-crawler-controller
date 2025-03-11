import QtQuick 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15

import "qml/Components"

ApplicationWindow {
    id: root
    visible: true
    width: 900
    height: 1000
    title: qsTr("Pipe Crawler Wheels Control")

    Row {
        id: mainLayout

        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 2

        Rectangle {
            id: diagramBackground

            color: "lightgray"

            width: childrenRect.width
            height: childrenRect.height

            RobotDiagram {
                id: robotDiagram

                width: 600
                height: 950
            }
        }

        Rectangle {
            id: selectorsBackgroud

            color: "gray"

            width: childrenRect.width
            height: root.height

            anchors.right: root.right

            Column {
                id: controlsLayout

                spacing: 20
                leftPadding: 10
                topPadding: 10
                rightPadding: 10

                Text {
                    font.pixelSize: 15
                    font.bold: true
                    color: "black"
                    text: qsTr("Presets/Drive modes")
                }

                ComboBox {
                    id: lockPresets

                    implicitContentWidthPolicy: ComboBox.WidestText
                    textRole: "title"
                    valueRole: "presetId"
                    model: [
                        {
                            presetId: 1,
                            title: qsTr("Left-Right wheel pairs")
                        }, {
                            presetId: 2,
                            title: qsTr("All cross pairs")
                        }]
                    onActivated:{ output.text = list.model[list.currentIndex] }
                }

                ComboBox {
                    id: driveModes

                    implicitContentWidthPolicy: ComboBox.WidestText
                    textRole: "title"
                    valueRole: "modeId"
                    model: [
                        {
                            modeId: 1,
                            title: qsTr("Full-drive")
                        }, {
                            modeId: 2,
                            title: qsTr("Front-drive")
                        }, {
                            modeId: 3,
                            title: qsTr("Rear-drive")
                        }]

                    onActivated:{ output.text = list.model[list.currentIndex] }
                }
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
