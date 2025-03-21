import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Components
import Controls

ApplicationWindow {
    id: root
    visible: true
    width: 1200
    height: 800
    minimumWidth: 1000
    minimumHeight: 700
    title: qsTr("Pipe Crawler Wheels Control")

    // Создаем контроллер
    VelocityController {
        id: velocityController
    }

    // Основной layout
    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Мнемосхема колесных пар
        WheelPairsGrid {
            Layout.fillWidth: true
            Layout.fillHeight: true
            velocityController: root.velocityController
        }

        // Панель управления
        ControlPanel {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            velocityController: root.velocityController
        }
    }

    // Верхнее меню
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            Action {
                text: qsTr("Exit")
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: qsTr("Help")
            Action {
                text: qsTr("About")
                onTriggered: aboutDialog.open()
            }
        }
    }

    // Диалог About
    Dialog {
        id: aboutDialog
        title: qsTr("About")
        standardButtons: Dialog.Ok
        modal: true
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Label {
            text: qsTr("Pipe Crawler Wheels Control\nVersion 1.0")
        }
    }
}
