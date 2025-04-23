import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    property alias controlsVisible: displayControlsBox.checked

    color: "lightgray"
    implicitHeight: contentLayout.implicitHeight + 20


    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        Text {
            id: title
            Layout.fillWidth: true
            font.pixelSize: 14
            font.bold: true
            color: "black"
            text: qsTr("Ray Position Controllers")
        }

        CheckBox {
            id: displayControlsBox
            checked: true
            text: qsTr("Display controls components")
        }
    }
}
