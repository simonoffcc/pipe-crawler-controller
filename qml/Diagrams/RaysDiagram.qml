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

    RayControl {
        id: rayControl

        rotation: 120
        isPointerOnRight: false

        anchors.centerIn: parent
    }

    RaySpinBox {
        id: raySpinBox

        visible: false

        anchors.centerIn: parent
    }
}
