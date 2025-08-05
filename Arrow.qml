import QtQuick

Item {
    id: arrowitem
    width: 20
    height: 20

    property color itemcolor: "gray"
    property color bordercolor: "black"
    property double angle: 0

    signal angleHasBeenChanged(int winkel)

    transform: Rotation { id: rotation; origin.x: arrowitem.width/2; origin.y: arrowitem.height/2; angle: arrowitem.angle}

    Canvas {
            id: canvas
            anchors.centerIn: parent
            height: parent.height
            width: parent.width

            antialiasing: true

            onPaint: {
                var ctx = canvas.getContext('2d')

                ctx.strokeStyle = bordercolor
                ctx.lineWidth = canvas.height * 0.05
                ctx.beginPath()
                ctx.moveTo(canvas.width * 0.05, canvas.height)
                ctx.lineTo(canvas.width / 2, canvas.height * 0.1)
                ctx.lineTo(canvas.width * 0.95, canvas.height)
                ctx.lineTo(canvas.width * 0.05, canvas.height)
                ctx.fillStyle = itemcolor //"rgb(80,80,80)"
                ctx.fill();
                ctx.stroke()
            }
        }

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: {

            if(arrowitem.angle === 0)
                arrowitem.angle = 90
            else
                arrowitem.angle = 0

            angleHasBeenChanged(arrowitem.angle)
        }

    }

}
