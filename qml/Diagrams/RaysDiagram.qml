import QtQuick

import Components

/*
тут будут собраны контроллеры для всех лучей с помощью:
        - RayControl (телеметрия + слайдер)
        - RaySpinBox (спинбокс + кнопка паблиш)
*/

Item {
    id: root

    width: 500
    height: 500

    Rectangle {
        width: rayControl.width + 1
        height: rayControl.height + 1
        border.color: "red"
        border.width: 1

        RayControl {
            id: rayControl

            rotation: 0
            isPointerOnRight: false

            anchors.centerIn: parent
        }
    }

    RaySpinBox {
        id: raySpinBox

        visible: false

        anchors.centerIn: parent
    }
}
