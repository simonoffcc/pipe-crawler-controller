import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Сетка для отображения всех колесных пар
Item {
    id: root

    property var velocityController
    property var activePairs: []

    // Размеры компонента
    implicitWidth: grid.implicitWidth + 32
    implicitHeight: grid.implicitHeight + 32

    // Фон
    Rectangle {
        anchors.fill: parent
        color: "#ffffff"
        border.color: "#d0d0d0"
        border.width: 1
        radius: 5
    }

    // Сетка колесных пар
    GridLayout {
        id: grid
        anchors.centerIn: parent
        columns: 3
        rowSpacing: 16
        columnSpacing: 16

        // Передние пары
        WheelPairControl {
            longitudinal: "front"
            transverse: "left"
            outerWheelSpeed: velocityController.getWheelSpeed("front", "left", "outer")
            innerWheelSpeed: velocityController.getWheelSpeed("front", "left", "inner")
            isActive: activePairs.indexOf("front_left") !== -1
        }

        WheelPairControl {
            longitudinal: "front"
            transverse: "up"
            outerWheelSpeed: velocityController.getWheelSpeed("front", "up", "outer")
            innerWheelSpeed: velocityController.getWheelSpeed("front", "up", "inner")
            isActive: activePairs.indexOf("front_up") !== -1
        }

        WheelPairControl {
            longitudinal: "front"
            transverse: "right"
            outerWheelSpeed: velocityController.getWheelSpeed("front", "right", "outer")
            innerWheelSpeed: velocityController.getWheelSpeed("front", "right", "inner")
            isActive: activePairs.indexOf("front_right") !== -1
        }

        // Задние пары
        WheelPairControl {
            longitudinal: "back"
            transverse: "left"
            outerWheelSpeed: velocityController.getWheelSpeed("back", "left", "outer")
            innerWheelSpeed: velocityController.getWheelSpeed("back", "left", "inner")
            isActive: activePairs.indexOf("back_left") !== -1
        }

        WheelPairControl {
            longitudinal: "back"
            transverse: "up"
            outerWheelSpeed: velocityController.getWheelSpeed("back", "up", "outer")
            innerWheelSpeed: velocityController.getWheelSpeed("back", "up", "inner")
            isActive: activePairs.indexOf("back_up") !== -1
        }

        WheelPairControl {
            longitudinal: "back"
            transverse: "right"
            outerWheelSpeed: velocityController.getWheelSpeed("back", "right", "outer")
            innerWheelSpeed: velocityController.getWheelSpeed("back", "right", "inner")
            isActive: activePairs.indexOf("back_right") !== -1
        }
    }

    // Обновление списка активных пар при изменении режимов
    Connections {
        target: velocityController
        function onDriveModeChanged() {
            updateActivePairs()
        }
        function onControlModeChanged() {
            updateActivePairs()
        }
    }

    // Функция обновления списка активных пар
    function updateActivePairs() {
        var pairs = []
        var prefixes = []

        // Определяем активные продольные позиции
        if (velocityController.driveMode === "all") {
            prefixes = ["front", "back"]
        } else {
            prefixes = [velocityController.driveMode]
        }

        // Формируем список активных пар
        for (var i = 0; i < prefixes.length; i++) {
            if (velocityController.controlMode === "sides") {
                pairs.push(prefixes[i] + "_left")
                pairs.push(prefixes[i] + "_right")
            } else { // transverse
                pairs.push(prefixes[i] + "_left")
                pairs.push(prefixes[i] + "_right")
                pairs.push(prefixes[i] + "_up")
            }
        }

        activePairs = pairs
    }

    Component.onCompleted: {
        updateActivePairs()
    }
} 