import QtQuick
import QtQuick.Controls
import QtQml
import QtQuick.Dialogs
Item {
    id:dialg
    width:mainwin.width
    height:mainwin.height
    property int number : 0
    z:100
    MouseArea{
        anchors.fill:parent
        onClicked: destr.start()
    }
    Rectangle{
        anchors.fill:parent
        scale:1.1
        color:Qt.alpha(Material.background,0.5)
        radius:40
    }
    ParallelAnimation{
        running:true
        NumberAnimation{target:dialg; property:"opacity"; from:0.25; to:1; duration:150; easing.type:Easing.Linear}
        NumberAnimation{target:dialg; property:"scale"; from:0.95; to:1; duration:150; easing.type:Easing.Linear}
    }
    ParallelAnimation{
        id:animate
        NumberAnimation{id:animate1;target:dialg ;property:"opacity"; from:0.25; to:1; duration:150; easing.type:Easing.Linear}
        NumberAnimation{id:animate2;target:dialg ;property:"scale"; from:0.95; to:1; duration:150; easing.type:Easing.Linear}
    }

    Rectangle{

        id:dialgrect
        MouseArea{
            anchors.fill:parent

        }
        z:100
        radius:40
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.verticalCenter:parent.verticalCenter
        height:(mainwin.height-112)/1.1
        width:(mainwin.width-28)/1.1
        color:Material.primary
        Button{
            z:103
            id:filebutton
            height:parent.height/4
            width:parent.width/2
            anchors.bottom:parent.bottom
            anchors.bottomMargin: mainwin.width/25
            anchors.horizontalCenter: parent.horizontalCenter
            text:"Please choose a file"
            FileDialog{
                id: filedialog
                title:"Choose a file"
                onAccepted:{
                    filetextparent.text=filedialog.selectedFile
                    filetext.visible = true
                    filebutton.visible = false
                    devicebutton.visible = true
                }
            }
            onClicked:{
                filedialog.visible=true
            }
        }
        Text{
            visible:false
            id:filetext
            text:"Your file"
            color:Material.foreground
            height:parent.height/4
            width:parent.width/2
            anchors.top:parent.top
            anchors.topMargin: mainwin.width/25
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 24
            Text{
                width:parent.width
                height:font.pixelSize
                id:filetextparent
                anchors.top:parent.top
                anchors.topMargin: 30
                anchors.left:parent.left
                font.pixelSize: 24
                minimumPixelSize:12
                elide:Text.ElideLeft
                text:"?"
                fontSizeMode: Text.Fit
                color:Material.foreground
                Rectangle{
                    anchors.left:parent.left
                    anchors.top:parent.bottom
                    width:parent.width
                    height:3
                    color:Material.foreground
                    radius:2
                }
            }
        }



        Button{
            visible:false
            z:102
            id:devicebutton
            height:parent.height/4
            width:parent.width/2
            anchors.bottom:parent.bottom
            anchors.bottomMargin: mainwin.width/25
            anchors.horizontalCenter: parent.horizontalCenter
            text:"Please choose a device"
            onClicked:{
                devicerect.visible = true
                devicemodel.model = net.Get_listIp
                devicebutton.visible = false


            }
        }
        Text{

            id:devicetext
            visible:false
            text:"Your device"
            height:parent.height/4
            width:parent.width/2
            anchors.top:filetext.bottom
            anchors.bottomMargin: mainwin.width/25
            anchors.horizontalCenter: parent.horizontalCenter
            color:Material.foreground
            Text{
                id:devicetextparent
                anchors.top:parent.top
                anchors.topMargin: 30
                anchors.left:parent.left
                font.pixelSize: 18
                color:Material.foreground
                text:""
                Rectangle{
                    anchors.left:parent.left
                    anchors.top:parent.bottom
                    width:dialgrect.width/2
                    height:3
                    color:Material.foreground
                    radius:2
                }
            }
        }
        Rectangle{
            id:devicerect
            visible:false
            onVisibleChanged:{
                 animate1.target = devicerect
                 animate2.target = devicerect
                 animate.start()
            }
            width:parent.width/1.1
            height:parent.height/1.1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color:Material.background
            radius:50
            border.color:Material.foreground
            clip:true
            ListView{
                id:devicemodel
                width:devicerect.width
                height:75
                //model:net.Get_listIp
                anchors.fill: parent
                delegate:Rectangle{
                    width: devicerect.width
                    height: 100
                    color:Material.primary
                    radius:50
                    border.color:Material.foreground
                    border.width:2
                    RoundButton{
                      id:roundedbutton
                      visible:false
                      Component.onCompleted:{
                           if(textdelegate.text.substring(0,3) === "|W|")
                           {
                               roundedbutton.visible = true
                           }
                      }
                      height:parent.height/2
                      width:parent.heigth
                      anchors.verticalCenter: parent.verticalCenter
                      anchors.left:parent.left
                      anchors.leftMargin:25
                      onClicked:{
                          devicetextparent.text = modelData
                          devicerect.visible = false
                          devicetext.visible = true
                          continuebutton.visible = true

                      }
                    }

                    Text{
                        id:textdelegate
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left:roundedbutton.right
                        anchors.leftMargin: 25
                        text: modelData
                        color:Material.foreground
                        }
                }


            }
            Button{
                id:updatebutton
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                width:100
                height:100
                text:"update"
                onClicked:{
                    devicemodel.model = net.Get_listIp
                }
            }

        }



        Button{
            SequentialAnimation{
                id:destr
                ParallelAnimation{
                    NumberAnimation{target:dialg ;property:"opacity"; from:1; to:0.25; duration:150; easing.type:Easing.Linear}
                    NumberAnimation{target:dialg ;property:"scale"; from:1; to:0.9; duration:150; easing.type:Easing.Linear}
                }
                ScriptAction{script:dialg.destroy()}
            }
            visible:false
            z:102
            id:continuebutton
            height:parent.height/4
            width:parent.width/2
            anchors.bottom:parent.bottom
            anchors.bottomMargin: mainwin.width/25
            anchors.horizontalCenter: parent.horizontalCenter
            text:"continue"
            onClicked:{
                devicetextparent.text = devicetextparent.text.substring(3)
                onClicked: lsmodel.append({
                                   "device":devicetextparent.text,
                                   "file":filetextparent.text,
                                   "idorecieve":0
                               })

                destr.start()
            }
        }

    }

}
