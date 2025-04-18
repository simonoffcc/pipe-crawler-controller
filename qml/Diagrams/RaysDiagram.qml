import QtQuick

import Components

Item {
    id: root

    width: 430
    height: 910

    RayControl {
        id: rayIndicator

        anchors.centerIn: parent
    }

    RaySpinBox {
        id: raySpinBox

        anchors {
            bottom: rayIndicator.top
            bottomMargin: 10
        }
    }
}
