import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    property var velocityController

    color: "#f5f5f5"
    border.color: "#d0d0d0"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Режимы управления
        GroupBox {
            Layout.fillWidth: true
            title: "Control Modes"

            ColumnLayout {
                anchors.fill: parent
                spacing: 8

                // Режим привода
                Label {
                    text: "Drive Mode:"
                    font.bold: true
                }

                RowLayout {
                    spacing: 8
                    RadioButton {
                        text: "All"
                        checked: velocityController.driveMode === "all"
                        onClicked: velocityController.setDriveMode("all")
                    }
                    RadioButton {
                        text: "Front"
                        checked: velocityController.driveMode === "front"
                        onClicked: velocityController.setDriveMode("front")
                    }
                    RadioButton {
                        text: "Back"
                        checked: velocityController.driveMode === "back"
                        onClicked: velocityController.setDriveMode("back")
                    }
                }

                // Режим управления
                Label {
                    text: "Control Mode:"
                    font.bold: true
                }

                RowLayout {
                    spacing: 8
                    RadioButton {
                        text: "Sides"
                        checked: velocityController.controlMode === "sides"
                        onClicked: velocityController.setControlMode("sides")
                    }
                    RadioButton {
                        text: "Transverse"
                        checked: velocityController.controlMode === "transverse"
                        onClicked: velocityController.setControlMode("transverse")
                    }
                }
            }
        }

        // Управление скоростью для режима sides
        GroupBox {
            Layout.fillWidth: true
            title: "Side Control"
            visible: velocityController.controlMode === "sides"

            GridLayout {
                anchors.fill: parent
                columns: 2
                rowSpacing: 8
                columnSpacing: 16

                Label {
                    text: "Left Side:"
                    Layout.alignment: Qt.AlignRight
                }
                RowLayout {
                    SpinBox {
                        id: leftSpeedSpinBox
                        from: -100
                        to: 100
                        stepSize: 1
                        value: velocityController.getSideSpeed("left") * 100
                        onValueChanged: velocityController.setSideSpeed("left", value / 100.0)
                    }
                    Label {
                        text: "rad/s"
                    }
                }

                Label {
                    text: "Right Side:"
                    Layout.alignment: Qt.AlignRight
                }
                RowLayout {
                    SpinBox {
                        id: rightSpeedSpinBox
                        from: -100
                        to: 100
                        stepSize: 1
                        value: velocityController.getSideSpeed("right") * 100
                        onValueChanged: velocityController.setSideSpeed("right", value / 100.0)
                    }
                    Label {
                        text: "rad/s"
                    }
                }
            }
        }

        // Управление скоростью для режима transverse
        GroupBox {
            Layout.fillWidth: true
            title: "Transverse Control"
            visible: velocityController.controlMode === "transverse"

            GridLayout {
                anchors.fill: parent
                columns: 2
                rowSpacing: 8
                columnSpacing: 16

                Label {
                    text: "Left Pairs:"
                    Layout.alignment: Qt.AlignRight
                }
                RowLayout {
                    SpinBox {
                        id: leftPairsSpeedSpinBox
                        from: -100
                        to: 100
                        stepSize: 1
                        value: velocityController.getTransverseSpeed("left") * 100
                        onValueChanged: velocityController.setTransverseSpeed("left", value / 100.0)
                    }
                    Label {
                        text: "rad/s"
                    }
                }

                Label {
                    text: "Right Pairs:"
                    Layout.alignment: Qt.AlignRight
                }
                RowLayout {
                    SpinBox {
                        id: rightPairsSpeedSpinBox
                        from: -100
                        to: 100
                        stepSize: 1
                        value: velocityController.getTransverseSpeed("right") * 100
                        onValueChanged: velocityController.setTransverseSpeed("right", value / 100.0)
                    }
                    Label {
                        text: "rad/s"
                    }
                }

                Label {
                    text: "Up Pairs:"
                    Layout.alignment: Qt.AlignRight
                }
                RowLayout {
                    SpinBox {
                        id: upPairsSpeedSpinBox
                        from: -100
                        to: 100
                        stepSize: 1
                        value: velocityController.getTransverseSpeed("up") * 100
                        onValueChanged: velocityController.setTransverseSpeed("up", value / 100.0)
                    }
                    Label {
                        text: "rad/s"
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
} 