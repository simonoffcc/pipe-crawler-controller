import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root

    property alias controlsVisible: displayControlsCheckBox.checked

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
            id: displayControlsCheckBox

            text: qsTr("Display controls components")
            checked: true

            ToolTip.visible: displayControlsCheckBox.hovered
            ToolTip.text: displayControlsCheckBox.checked ? qsTr("Hide rays controls") : qsTr("Show rays controls")
            ToolTip.timeout: 3000

            indicator.implicitWidth: 18
            indicator.implicitHeight: 18

            contentItem: Text {
                text: displayControlsCheckBox.text
                font: displayControlsCheckBox.font
                color: "black"
                verticalAlignment: Text.AlignVCenter
                leftPadding: displayControlsCheckBox.indicator.width + displayControlsCheckBox.spacing
            }
        }
    }
}
