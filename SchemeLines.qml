import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.strokeStyle = "black";
            ctx.lineWidth = 2;

            ctx.beginPath();

            ctx.moveTo(width / 4, height / 4);
            ctx.lineTo(width / 2, height / 4);

            ctx.moveTo(width / 4, height / 4);
            ctx.lineTo(width / 4, 3 * height / 4);

            ctx.moveTo(0, 3 * height / 4);
            ctx.lineTo(width, 3 * height / 4);

            ctx.moveTo(width / 2, 3 * height / 4);
            ctx.lineTo(width / 2, 3 * height);

            ctx.stroke();
        }
    }
}
