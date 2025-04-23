import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root

    property alias controlsVisible: displayControlsBox.checked

    color: "lightgray"
    implicitHeight: contentLayout.implicitHeight + contentLayout.spacing + contentLayout.anchors.bottomMargin

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
            Layout.fillWidth: true

            checked: true
            text: qsTr("Display controls components")
            contentItem: Text {
                color: "black";
                text: displayControlsBox.text
                verticalAlignment: Text.AlignVCenter
                leftPadding: displayControlsBox.indicator.width + displayControlsBox.spacing
            }
        }
    }
}
