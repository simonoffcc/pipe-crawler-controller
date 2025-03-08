import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    property bool isFront: true
    property int elementStrokeWidth: 4

    width: 100
    height: 250

    JointControl {
        id: outerJoint
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: { if (!isFront) connectionLine.bottom; }
            bottom: { if (isFront) connectionLine.top; }
        }

        width: root.width
        height: root.width
        border.width: elementStrokeWidth
    }

    PairConnection {
        id: connectionLine
        visible: true

        anchors.centerIn: parent

        height: root.width / 2
        width: elementStrokeWidth
    }

    JointControl {
        id: innerJoint
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: { if (isFront) connectionLine.bottom; }
            bottom: { if (!isFront) connectionLine.top; }
        }

        width: root.width
        height: root.width
        border.width: elementStrokeWidth
    }
}
