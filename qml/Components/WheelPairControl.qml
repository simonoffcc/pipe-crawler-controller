import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Компонент для отображения и управления колесной парой
Item {
    id: root

    property string longitudinal: "front" // "front" или "back"
    property string transverse: "left"    // "left", "right" или "up"
    property double outerWheelSpeed: 0.0
    property double innerWheelSpeed: 0.0
    property double targetSpeed: 0.0
    property bool isActive: false

    width: 200
    height: 150

    Rectangle {
        id: background
        anchors.fill: parent
        color: isActive ? "#e0e0e0" : "#f0f0f0"
        border.color: "#808080"
        border.width: 1
        radius: 5

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.longitudinal + "_" + root.transverse
                font.bold: true
            }

            // Отображение текущих скоростей
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 4
                columnSpacing: 8

                Label {
                    text: "Outer:"
                    Layout.alignment: Qt.AlignRight
                }
                Label {
                    text: outerWheelSpeed.toFixed(2)
                    Layout.fillWidth: true
                }

                Label {
                    text: "Inner:"
                    Layout.alignment: Qt.AlignRight
                }
                Label {
                    text: innerWheelSpeed.toFixed(2)
                    Layout.fillWidth: true
                }

                Label {
                    text: "Target:"
                    Layout.alignment: Qt.AlignRight
                }
                Label {
                    text: targetSpeed.toFixed(2)
                    Layout.fillWidth: true
                }
            }
        }
    }
} 