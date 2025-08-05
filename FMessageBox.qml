import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Fusion

Item {
    id: messageitem
    width: parent.width > 430 ? 400 : 300
    height: messagetxt.height + caption.height + closebutton.height > 100 ? messagetxt.height + 20 + caption.height + closebutton.height : 100
    anchors.centerIn: parent
    z:2

    property string messagetext: "This is a long text to test the wrap mode of this message. Just to make sure that the words are showing correctly in this message! What happen when this text is longer than the box is no heigh enough to cover this message text. This situation could be when this app running in android or the main window get really very small."
    property string textcolor: "navy"

    Rectangle{
        id: messagerect
        width: parent.width
        height: parent.height
        color: "ivory"
        border.color: "gray"
        radius: 5

        Text {
            id: caption
            x: parent.width/2 - caption.width/2
            y: 10
            text: qsTr("Messagebox")
            font.underline: true
            color: "teal"
            font.letterSpacing: 2
            font.pointSize: mainwindow.android ? 15 : 12
        }

        Text {
            id: messagetxt
            text: messagetext
            color: textcolor
            wrapMode: Text.WordWrap
            width: parent.width - 30
            x: 20
            y: 40

        }

        MouseArea{
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
        }

        Button{
            id: closebutton
            text: "X"
            x:5; y:5
            onClicked: { messageitem.visible = false }
        }

        Rectangle{
            id: shadesloginrect
            width: parent.width + 5
            height: parent.height + 5
            color: "black"
            border.color: "gray"
            opacity: 0.35
            x:10; y:10;
            z:-1
            radius: 5
        }
    }
}
