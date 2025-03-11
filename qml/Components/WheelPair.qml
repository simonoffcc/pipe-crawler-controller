import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    property int jointControlWidth: 100
    property int elementStrokeWidth: 4
    property bool isFront: true

    width: jointControlWidth
    height: jointControlWidth * 2.5

    JointControl {
        id: outerJoint
        visible: true

        width: jointControlWidth
        height: jointControlWidth
        border.width: elementStrokeWidth

        Component.onCompleted: {
            anchors.horizontalCenter = parent.horizontalCenter
            isFront ? anchors.bottom = connectionLine.top : anchors.top = connectionLine.bottom
        }
    }

    PairConnection {
        id: connectionLine
        visible: true

        anchors.centerIn: parent

        height: jointControlWidth / 2
        width: elementStrokeWidth
    }

    JointControl {
        id: innerJoint
        visible: true

        width: jointControlWidth
        height: jointControlWidth
        border.width: elementStrokeWidth

        Component.onCompleted: {
            anchors.horizontalCenter = parent.horizontalCenter
            !isFront ? anchors.bottom = connectionLine.top : anchors.top = connectionLine.bottom
        }
    }
}
