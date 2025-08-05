import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Fusion
import QtQuick.Dialogs
import QtQuick.Layouts
import QtCore

import FSHKData 1.0

Window {
    id: mainwindow
    width: 640
    minimumWidth: 300
    height: 480
    visible: true
    title: Qt.application.name
    color: "teal"

    property int rectheight: mainrect.height / 5 - buttonrow.height / 5
    property bool android: false
    property int  winkela: 0
    property int  winkelb: 0
    property int  winkelc: 0
    property int  winkeld: 0
    property color answerAcolor: "orange"
    property color answerBcolor: "salmon"
    property color answerCcolor: "red"
    property color answerDcolor: "darkred"
    property url documentsFolder: StandardPaths.writableLocation(StandardPaths.DownloadLocation)
    property url imageAurl: ""
    property url imageBurl: ""
    property url imageCurl: ""
    property url imageDurl: ""
    property url imageQurl: ""
    property string statusimage: ""
    property bool showmenu: true

    // C++ Class
    FData{
        id: shkdata
        onSendInfoMessage: messagetext=> {

                               message.messagetext = messagetext
                               message.visible = true

                           }
    }

    FileDialog{
        id: filedialog
        options: FileDialog.DontResolveSymlinks
        nameFilters:  [ "Images (*.png)","JPG (*.JPG)", "jpg (*.jpg)" ]
        onAccepted: {

            if(statusimage === "imagea"){
                imageAurl = selectedFile
                imagearect.visible = true
            }

            if(statusimage === "imageb"){
                imageBurl = selectedFile
                imagebrect.visible = true
            }

            if(statusimage === "imagec"){
                imageCurl = selectedFile
                imagecrect.visible = true
            }

            if(statusimage === "imaged"){
                imageDurl = selectedFile
                imagedrect.visible = true
            }

            if(statusimage === "imageq"){
                imageQurl = selectedFile
                imageqrect.visible = true
            }

        }
        currentFolder: documentsFolder
    }

    DialogLogin{ id: login }

    DialogInfo{ id: info }

    FMessageBox{ id: message; visible: false }

    function calculateRectHeight(){

        var buttonrowheigt = buttonrow.height

        var teiler = 5
        var i = 0
        var margin = addAButton.height + 4

        if(winkela === 90) i++
        if(winkelb === 90) i++
        if(winkelc === 90) i++
        if(winkeld === 90) i++

        teiler = teiler - i;

        rectheight = (mainrect.height - buttonrow.height - (i * 30) ) / teiler
    }

    function checkQuestionsData(){

        var status = false

        if(questedit.text.length > 0 &&
            answeraedit.text.length > 0 &&
                answerbedit.text.length > 0 &&
                    answercedit.text.length > 0 &&
                        answerdedit.text.length > 0)
                status = true

        if(statusA.checked === false && statusB.checked === false &&
                statusC.checked === false && statusD.checked === false )
            status = false


        saveButton.enabled = status
    }

    ListModel {
        id: klassmodel
        ListElement { text: "MAS 26-1" }
        ListElement { text: "MAS 25-1" }
        ListElement { text: "MAS 24-1" }
        ListElement { text: "MAS 23-1" }
        ListElement { text: "MAS 22-1" }
    }

    Rectangle{
        id: menubutton
        width: 15
        height: 32
        anchors.right: parent.right
        anchors.rightMargin: 5
        y:5
        MouseArea{
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: {

                showmenu === true ? showmenu = false : showmenu = true

                //showmenu === false ? buttonrow.height = 0 : buttonrow.height = saveButton.height + 4
                console.log(showmenu)
            }
        }
    }

    // Image for display in the center of app
    Image {
        id: wrench
        width: parent.height / 100 * 50
        height: parent.height / 100 * 50 //200
        source: "qrc:/WaterpumpWrench.svg"
        anchors.centerIn: parent
    }


    Rectangle{
        id: mainrect
        width: parent.width-10
        height: parent.height-10
        x:5 ; y:5
        border.color: "white"
        color: "transparent"
        opacity: 1.0

        Flow{
            id: buttonrow
            width: parent.width - 5
            x:5; y:5
            spacing: android ? 3 : 5
            visible: showmenu
            Button{
                id: saveButton
                width: android ? 70 : 80
                text: "&save"
                enabled: false
                onClicked: {

                    var obj = {"question":questedit.text, "answerA":answeraedit.text, "answerB":answerbedit.text,
                    "answerC":answercedit.text, "answerD":answerdedit.text, "statusA": statusA.checked,
                    "statusB": statusB.checked, "statusC": statusC.checked, "statusD": statusD.checked,
                    "imageA":imageAurl, "imageB":imageBurl, "imageC":imageCurl, "imageD":imageDurl, "imageQ":imageQurl }

                    shkdata.saveData(obj)
                }
            }
            Button{
                id: changeButton
                width: android ? 70 : 80
                text: "&change"
                enabled: false
                onClicked: { }
            }
            Button{
                id: sentButton
                width: android ? 70 : 80
                text: "sen&d"
                enabled: false
                onClicked: { }
            }
            Button{
                id: infoButton
                width: android ? 70 : 80
                text: "&info"
                onClicked: { info.open()  }
            }
            Button{
                id: loginButton
                width: android ? 70 : 80
                text: "&login"
                onClicked: { login.visible = true }
            }
            Button{
                id: closeButton
                width: android ? 70 : 80
                text: "&close"
                onClicked: Qt.quit()
            }
            onHeightChanged: { calculateRectHeight() }
        }

        // Question
        Rectangle{
            id: questionrect
            width: parent.width
            height: rectheight > questedit.height + txt1.height ? rectheight : questedit.height + txt1.height + 10
            anchors.top: buttonrow.bottom
            border.color: "beige"
            color: "transparent"

            Row{
                height: 20
                x:5; y:5
                spacing: 10

                Text { id: txt1; height:20; text: "Question:"; color: "white"; font.letterSpacing: 1.2 }
                Button{ id: addQButton; text: "+"; width: 20; onClicked: { filedialog.open() ; statusimage = "imageq" }  }

            }

            TextEdit{
                id: questedit
                text: ""
                width:  imageqrect.visible ? questionrect.width - imageqrect.width - 8 : questionrect.width - 15
                x:10; y: addQButton.height + 6
                color: "white"
                cursorVisible: focus ? true : false
                wrapMode: Text.WordWrap
                onTextChanged: {  checkQuestionsData()  }
            }

            Rectangle{
                id: imageqrect
                width: imageqrect.height
                height: questionrect.height - 5
                anchors.bottom: questionrect.bottom
                anchors.right: questionrect.right
                anchors.margins: 3
                border.color: "beige"
                color: "transparent"
                visible: false
                Image {
                    id: imageQ
                    //z:2
                    width: imageqrect.width - 2
                    height: imageqrect.height -2
                    anchors.centerIn: parent
                    source: imageQurl
                }
                Button{
                    id: buttonq
                    visible: true
                    width: 15; height: 15
                    text: "x"
                    onClicked: { imageQurl = "";  imageqrect.visible = false   }
                }
            }
        }

        // Answer A
        Rectangle{
            id: answerArect
            width: parent.width
            height: winkela > 0 ? 30 : rectheight
            anchors.top: questionrect.bottom
            border.color: answerAcolor
            color: "transparent"

            Arrow{
                id: arrowA
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 5
                itemcolor: answerAcolor
                bordercolor: "dimgray"
                onAngleHasBeenChanged: winkel=> { winkela = winkel; calculateRectHeight() }
            }

            Row{
                height: 20
                x:5; y:5
                spacing: 5

                Text { id: txt2; height:20; text: "Answer A"; color: "white"; font.letterSpacing: 1.2 }
                CheckBox{ id: statusA; height: 20; onCheckedChanged: { checkQuestionsData() } }
                Button{ id: addAButton; text: "+"; width: 20; onClicked: { filedialog.open() ; statusimage = "imagea" }  }

            }

            TextEdit{
                id: answeraedit
                text: ""
                width: answerArect.width - 15
                x:10; y:30
                color: "white"
                cursorVisible: focus ? true : false
                wrapMode: Text.WordWrap
                visible: winkela > 0 ? false : true
                onTextChanged: { checkQuestionsData() }
            }

            Rectangle{
                id: imagearect
                width: imagearect.height
                height: answerArect.height - arrowA.height - 8
                anchors.bottom: answerArect.bottom
                anchors.right:answerArect.right
                anchors.margins: 3
                border.color: "salmon"
                color: "transparent"
                visible: false
                Image {
                    id: imageA
                    //z:2
                    width: imagearect.width - 2
                    height: imagearect.height -2
                    anchors.centerIn: parent
                    source: imageAurl
                }
                Button{
                    id: buttona
                    visible: winkela < 90 ? true : false
                    width: 15; height: 15
                    text: "x"
                    onClicked: { imageAurl = "";  imagearect.visible = false   }
                }
            }

        }

        // Answer B
        Rectangle{
            id: answerBrect
            width: parent.width
            height: winkelb > 0 ? arrowB.height+15 : rectheight
            anchors.top: answerArect.bottom
            border.color: answerBcolor
            color: "transparent"

            Arrow{
                id: arrowB
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 5
                itemcolor: answerBcolor
                bordercolor: "dimgray"
                onAngleHasBeenChanged: winkel=> { winkelb = winkel; calculateRectHeight() }
            }

            Row{
                height: addBButton.height
                x:5; y:5
                spacing: 5

                Text { id: txt3; height:addBButton.height; text: "Answer B"; color: "white"; font.letterSpacing: 1.2 }
                CheckBox{ id: statusB; height: addBButton.height; onCheckedChanged: { checkQuestionsData() } }
                Button{ id: addBButton; text: "+"; width: 20; onClicked: { filedialog.open() ; statusimage = "imageb" }  }
            }

            TextEdit{
                id: answerbedit
                text: ""
                width: answerBrect.width - 15
                x:10; y:30
                color: "white"
                cursorVisible: focus ? true : false
                wrapMode: Text.WordWrap
                visible: winkelb > 0 ? false : true
                onTextChanged: { checkQuestionsData() }
            }

            Rectangle{
                id: imagebrect
                width: imagebrect.height
                height: answerBrect.height - arrowB.height - 8
                anchors.bottom: answerBrect.bottom
                anchors.right:answerBrect.right
                anchors.margins: 3
                border.color: "salmon"
                color: "transparent"
                visible: false
                Image {
                    id: imageB
                    //z:2
                    width: imagebrect.width - 2
                    height: imagebrect.height -2
                    anchors.centerIn: parent
                    source: imageBurl
                }
                Button{
                    id: buttonb
                    width: 15; height: 15
                    text: "x"
                    visible: winkelb < 90 ? true : false
                    onClicked: { imageBurl = "";  imagebrect.visible = false   }
                }
            }
        }

        // Answer C
        Rectangle{
            id: answerCrect
            width: parent.width
            height: winkelc > 0 ? arrowC.height+15 : rectheight
            anchors.top: answerBrect.bottom
            border.color: "red"
            color: "transparent"

            Arrow{
                id: arrowC
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 5
                itemcolor: answerCcolor
                bordercolor: "dimgray"
                onAngleHasBeenChanged: winkel=> { winkelc = winkel;  calculateRectHeight() }
            }

            Row{
                height: addCButton.height
                x:5; y:5
                spacing: 5

                Text { id: txt4; height:addCButton.height; text: "Answer C"; color: "white"; font.letterSpacing: 1.2 }
                CheckBox{ id: statusC; height: addBButton.height; onCheckedChanged: { checkQuestionsData() } }
                Button{ id: addCButton; text: "+"; width: 20; onClicked: { filedialog.open() ; statusimage = "imagec" }  }
            }

            TextEdit{
                id: answercedit
                text: ""
                width: answerCrect.width - 15
                x:10; y:30
                color: "white"
                cursorVisible: focus ? true : false
                wrapMode: Text.WordWrap
                visible: winkelc > 0 ? false : true
                onTextChanged: {  }
            }


            Rectangle{
                id: imagecrect
                width: imagecrect.height
                height: answerCrect.height - arrowC.height - 8
                anchors.bottom: answerCrect.bottom
                anchors.right:answerCrect.right
                anchors.margins: 3
                border.color: answerCcolor
                color: "transparent"
                visible: false
                Image {
                    id: imageC
                    //z:2
                    width: imagecrect.width - 2
                    height: imagecrect.height -2
                    anchors.centerIn: parent
                    source: imageCurl
                }
                Button{
                    id: buttonc
                    width: 15; height: 15
                    text: "x"
                    visible: winkelc < 90 ? true : false
                    onClicked: { imageCurl = "";  imagecrect.visible = false   }
                }
            }
        }

        // Answer D
        Rectangle{
            id: answerDrect
            width: parent.width
            height: winkeld > 0 ? arrowD.height+15 : rectheight
            anchors.top: answerCrect.bottom
            border.color: answerDcolor
            color: "transparent"

            Arrow{
                id: arrowD
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 5
                itemcolor: answerDcolor
                bordercolor: "dimgray"
                onAngleHasBeenChanged: winkel=> { winkeld = winkel;  calculateRectHeight() }
            }

            Row{
                height: addDButton.height
                x:5; y:5
                spacing: 5

                Text { id: txt5; height:addDButton.height; text: "Answer D"; color: "white"; font.letterSpacing: 1.2 }
                CheckBox{ id: statusD; height: addDButton.height; onCheckedChanged: { checkQuestionsData() } }
                Button{ id: addDButton; text: "+"; width: 20; onClicked: { filedialog.open() ; statusimage = "imaged" }  }
            }

            TextEdit{
                id: answerdedit
                text: ""
                width: answerDrect.width - 15
                x:10; y:30
                color: "white"
                cursorVisible: focus ? true : false
                wrapMode: Text.WordWrap
                visible: winkeld > 0 ? false : true
                onTextChanged: { checkQuestionsData() }
            }

            Rectangle{
                id: imagedrect
                width: imagedrect.height
                height: answerDrect.height - arrowD.height - 8
                anchors.bottom: answerDrect.bottom
                anchors.right:answerDrect.right
                anchors.margins: 3
                border.color: answerDcolor
                color: "transparent"
                visible: false
                Image {
                    id: imageD
                    //z:2
                    width: imagedrect.width - 2
                    height: imagedrect.height -2
                    anchors.centerIn: parent
                    source: imageDurl
                }
                Button{
                    id: buttond
                    visible: winkeld < 90 ? true : false
                    width: 15; height: 15
                    text: "x"
                    onClicked: { imageDurl = "";  imagedrect.visible = false   }
                }
            }
        }
    }

    Component.onCompleted: {

        if(Qt.platform.os === "android")
            android = true


    }
}
