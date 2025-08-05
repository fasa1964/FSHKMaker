import QtQuick
import QtQuick.Controls.Fusion

Rectangle {
    id: inforect
    width: parent.width - 60
    height: parent.height / 2 > infotext.height + grid1.height + caption.height + 20 ? parent.height / 2 : infotext.height + grid1.height + caption.height + 55
    x: parent.width / 2 - inforect.width / 2
    y: 60
    z:1
    radius: 5
    color: "darkcyan"
    border.color: "white"
    visible: false

    property bool sslsupport: false
    property bool online: false

    // Everytime to open this dialog will check the internet status
    function open(){
        inforect.visible = true
        sslsupport = shkdata.sslsupport()
        online = shkdata.online()
    }

    function close(){
        inforect.visible = false
    }

    Text {
        id: caption
        x: parent.width/2 - caption.width/2
        y: 10
        text: qsTr("Info")
        font.underline: true
        color: "white"
        font.letterSpacing: 2
        font.pointSize: mainwindow.android ? 15 : 12
    }

    Button{
        id: infoCloseButton
        text: "x"
        x:5; y:5
        onClicked: { inforect.visible = false }
    }

    Grid{
        id: grid1
        columns: 4
        columnSpacing: 15
        rowSpacing: 10
        anchors.top: caption.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        Text {
            id:txt6
            text: qsTr("Online:")
            color: "white"
        }
        FLed{ id: onlineled; ledheight: txt6.height-2; ledlight: online ? "lime" : "red" }
        Text {
            id:txt7
            text: qsTr("Ssl-Support:")
            color: "white"
        }
        FLed{ id: sslled; ledheight: txt7.height-2; ledlight: sslsupport ? "lime" : "red" }
    }


    Text{
        id: infotext
        width: parent.width-30
        anchors.top: grid1.bottom
        anchors.topMargin: 15
        anchors.left: grid1.left
        text: shkdata.infoText()
        wrapMode: Text.WordWrap
        color: "white"
    }

    Rectangle{
        id: shadowrect
        width: parent.width
        height: parent.height
        color: "black"
        opacity: 0.35
        x:10; y:10
        z:-1
        radius: 5
    }


}
