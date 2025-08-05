import QtQuick
import QtQuick.Controls.Fusion

Rectangle {
    id: loginrect
    width: parent.width-60
    height: 200
    anchors.centerIn: parent
    z:2
    color: "cornsilk"
    radius: 5
    visible: false

    onWidthChanged: {  if(width > 600) { width = 600 }   }

    Text {
        id: caption
        text: qsTr("Login dialog")
        color: "teal"
        x: parent.width/2 - caption.width/2
        y:10
        font.pointSize: 12
        font.letterSpacing: 1.5
    }

    Button{
        text: "x"
        x:5; y:5
        onClicked: {

            loginrect.visible = false;

            // Copy everything in QVariantList / QVariantMap
            var obj = {"firstname":editfname.text, "lastname":editlname.text,
                "klass":klassBox.currentText, "index":klassBox.currentIndex }

            shkdata.setLoginData(obj)
        }
    }

    Column{
        anchors.centerIn: parent
        spacing: 5
        TextField{
            id: editfname
            text: shkdata.firstname
            width: 250
            height: 25
            placeholderText: "Enter your firstname"
            color: "blue"
        }
        TextField{
            id: editlname
            text: shkdata.lastname
            width: 250
            height: 25
            placeholderText: "Enter your lastname"
            color: "blue"
        }
        ComboBox{
            id: klassBox
            model: klassmodel
            currentIndex: shkdata.klassIndex
        }
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
