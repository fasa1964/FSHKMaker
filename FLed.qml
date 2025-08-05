import QtQuick

Rectangle {
   id: led
    width: ledheight
    height: ledheight
    radius: ledheight
    color: ledlight

    property int ledheight: 15
    property color rosette: "gray"
    property color ledlight: "silver"

    Rectangle{
        id:ros
        width: led.height+4
        height: led.height+4
        radius: ros.height/2
        color: "gray"
        x: led.width/2 - ros.width/2
        y: led.height/2 - ros.height/2
        z:-1
    }
}
