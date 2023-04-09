import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import Qt.labs.settings 1.0
Window {
    Settings{
        id:settings
        category:"main_window"
        fileName: "settings"
        property alias x:mainwin.x
        property alias y:mainwin.y
        property alias width: mainwin.width
        property alias height: mainwin.height
        property alias textip:storeip.text
        property alias textkey:store_key.text
        property alias textport:storeport.text
    }
    Settings_win{
        id:tmp
        ScriptAction{
            running: true
            script:tmp.destroy()
        }
    }
    id:mainwin
    width: 888
    height: 777
    visible: true
    title: "1"
    color:Material.background
    function tomyString(val) {
            return val.toString()
        }
    Connections{
        target:net
        function onAppendToModel(ip,file){
            lsmodel.append({
                        "device":ip,
                        "file":file,
                        "idorecieve":1
                        })
        }

    }


    ListView{

        anchors.fill:parent
        rotation: 0
        clip:true
        //header
        id:hh1
        headerPositioning: ListView.OverlayHeader
        header: Item{
            z:2
            anchors.horizontalCenter: parent.horizontalCenter
            width:mainwin.width
            height:56
            Rectangle{
                    border.color:Qt.lighter(Material.primary,0.7)
                    border.width:2
                    anchors.fill: parent
                    width:mainwin.width
                    height:parent.height
                    color:Material.primary
                    Button{
                        anchors.left:parent.left
                        anchors.bottomMargin: 2
                        anchors.leftMargin:5
                        width:parent.width/5
                        height:parent.height
                        text:"settings"
                        anchors.margins:5
                         onClicked:{
                          const component = Qt.createComponent("Settings_win.qml");
                          if(component.status === Component.Ready){
                             component.createObject(mainwin);
                             }
                     }
                     }
                    Text{
                            text:net.Get_serverIp
                            anchors.centerIn: parent
                            color:Material.foreground
                        }
            }

        }

         MouseArea{
            id:mouseareaforclose
            visible:false
            height:mainwin.height
            width:mainwin.width
            onClicked:{
                anim.first = mainwin.height/3
                anim.last = 0
                animtrue.start()
                mouseareaforclose.visible = false

            }}
        Rectangle{
            anchors.left:parent.left
            anchors.leftMargin:parent.width/12
            MouseArea{
                width:parent.width
                height:parent.width

            }

            id:rectwithinfo
            SequentialAnimation{
            id:animtrue
            ParallelAnimation
            {
                id:anim
                property int first:0
                property int last:0
                running:false
                NumberAnimation{
                    target:rectwithinfo
                    property:"opacity"
                    from:0.25
                    to:1
                    duration:300
                    easing.type:Easing.InOutQuad
                }
                NumberAnimation{
                    target:rectwithinfo
                    property:"height"
                    from:anim.first
                    to:anim.last
                    duration:300
                    easing.type:Easing.InOutQuad
                }}
                ScriptAction{script:if(anim.last==0){rectwithinfo.visible=false}}
            }
            visible:false
            onVisibleChanged:{
                anim.first = 0
                anim.last = mainwin.height/3
                animtrue.start()
            }

            border.color:Material.foreground
            radius:9
            width:parent.width/3
            height:parent.height/3
            color:Material.background
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 56
            TextField{
                id:storeip
                width:parent.width*0.9
                height:parent.height/4
                placeholderText: "enter ip"
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top:parent.top
                anchors.margins:parent.height/40
                font.pointSize:1+parent.height/16
            }
            TextField{
                width:parent.width*0.9
                id:storeport
                height:parent.height/4
                font.pointSize:1+parent.height/16
                placeholderText: "enter port"
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top:storeip.bottom
                anchors.margins:parent.height/40
            }
            TextField{

                width:parent.width*0.9
                id:store_key
                height:parent.height/4
                placeholderText: "enter key (if used)"
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top:storeport.bottom
                anchors.margins:parent.height/40
                font.pointSize:1+parent.height/16
            }
            Button{
                width:parent.width/2
                height:parent.height/6
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top:store_key.bottom
                anchors.margins:1
                onClicked:{net.tryToConnect(storeip.text,storeport.text,store_key.text)}
                text:"connect"
            }
        }
        footerPositioning: ListView.OverlayFooter
        footer: Item{
            id:ff1
            anchors.horizontalCenter: parent.horizontalCenter
            width:mainwin.width
            height:56
            Rectangle{

                id:rectangle_ff1
                anchors.fill: parent
                    border.color:Qt.lighter(Material.primary,0.7)
                    border.width:2
                    Button{
                        id:conbutton
                        anchors.left:parent.left
                     anchors.bottomMargin: 2
                        anchors.leftMargin:parent.width/12
                        width:parent.width/3
                        height:parent.height
                        text:"connect menu"
                     anchors.margins:5
                      onClicked:{
                            mouseareaforclose.visible=true
                            rectwithinfo.visible = true
                        }
                     }
                    color:Material.primary
                    Button{
                        width:parent.width/3
                        height:parent.height
                        text:"send"
                        anchors.right: parent.right
                        anchors.rightMargin:parent.width/12
                        onClicked:{
                        const component = Qt.createComponent("DialogWin.qml");
                        if(component.status === Component.Ready){
                            component.createObject(mainwin);
                            }
                        }
                        }
                     }
        }

        model: ListModel{
            id: lsmodel
        }

        delegate: Filesforsend{

        }





    }
}
