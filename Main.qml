import QtQuick 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15

import "qml/Components"

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

                anchors {
                    centerIn: parent
                }

                width: 600
                height: 950
            }
        }

        Rectangle {
            id: selectorsBackground

            color: "lightgray"
            Layout.minimumWidth: childrenRect.width
            Layout.preferredWidth: childrenRect.width * 1.5
            Layout.fillHeight: true


            Column {
                id: controlsLayout

                spacing: 20
                leftPadding: 10
                topPadding: 10
                rightPadding: 10

                anchors {
                    left: parent.left
                }

                Text {
                    id: controlsTitle

                    font.pixelSize: 16
                    color: "black"
                    text: qsTr("Presets/Drive modes")
                }

                ComboBox {
                    id: lockPresets

                    implicitContentWidthPolicy: ComboBox.WidestText
                    textRole: "title"
                    valueRole: "presetId"
                    model: [
                        { presetId: 0, title: qsTr("Custom") },
                        { presetId: 1, title: qsTr("Left-Right wheel pairs") },
                        { presetId: 2, title: qsTr("All cross pairs") }
                    ]
                    onActivated: lockPresetOutput.text = lockPresets.model[lockPresets.currentIndex].title
                }

                ComboBox {
                    id: driveModes

                    implicitContentWidthPolicy: ComboBox.WidestText
                    textRole: "title"
                    valueRole: "modeId"
                    model: [
                        { modeId: 0, title: qsTr("Custom") },
                        { modeId: 1, title: qsTr("Full-drive") },
                        { modeId: 2, title: qsTr("Front-drive") },
                        { modeId: 3, title: qsTr("Rear-drive") }
                    ]
                    onActivated: driveModeOutput.text = driveModes.model[driveModes.currentIndex].title
                }

                Text {
                    id: chosenSettingsTitle

                    font.pixelSize: 16
                    color: "black"
                    text: qsTr("Current Settings")
                }

                Text {
                    id: lockPresetOutput

                    font.pixelSize: 15
                    color: "black"
                    text: qsTr("All cross pairs")
                }

                Text {
                    id: driveModeOutput

                    font.pixelSize: 15
                    color: "black"
                    text: qsTr("Full-drive")
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
