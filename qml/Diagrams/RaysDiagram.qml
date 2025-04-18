import QtQuick

import Components

/*
тут будут собраны контроллеры для всех лучей с помощью:
        - RayControl (телеметрия + слайдер)
        - RaySpinBox (спинбокс + кнопка паблиш)
*/

Item {
    id: root

    width: 430
    height: 910

    RayControl {
        id: rayIndicator

        visible: false

        anchors.centerIn: parent
    }

    RaySpinBox {
        id: raySpinBox

        anchors.centerIn: parent
    }
}
