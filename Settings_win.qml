import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import Qt.labs.settings
Item {
    Settings{
        id:settings
        category:"settings"
        fileName: "settings"
        property alias key_usage:key.checked
        property alias key_string:key_text.text
    }
    id:root
    height:parent.height
    width:parent.width
    ParallelAnimation{
        running:true
        NumberAnimation{target:root; property:"opacity"; from:0.25; to:1; duration:300; easing.type:Easing.Linear}
        NumberAnimation{target:root; property:"x"; from:-parent.width; to:0; duration:300; easing.type:Easing.Linear}
    }
    SequentialAnimation{
        id:anim
        ParallelAnimation{
            NumberAnimation{target:root; property:"opacity"; from:1; to:0.56; duration:300; easing.type:Easing.Linear}
            NumberAnimation{target:root; property:"x"; from:0; to:-parent.width; duration:300; easing.type:Easing.Linear}
        }
        ScriptAction{
            script:{
                key.job()
                root.destroy()}
        }
    }

    Rectangle{
        height:parent.height
        width:parent.width
        color:Material.background
    Button{
        anchors.left:parent.left
        anchors.bottomMargin: 2
        anchors.leftMargin:5
        height:parent.height/20
        width:parent.height/10
        text:qsTr("<--")
        onClicked:{

            anim.start()
        }

    }

    }
    Column{
        anchors.fill: parent
        anchors.margins: 35
        anchors.topMargin:parent.height/20
        width:parent.width-30
        height:parent.width-30
        spacing:5
        Switch{
            function job(){
                if(checked==true){
                    key_text.visible = true
                    net.set_key(1,key_text.text)
                }
                else{
                    key_text.visible = false
                    net.set_key(0,"")
                }
            }

            id:key
            text:qsTr("use a key to connect")
            onToggled:{
                job()
            }
            Component.onCompleted:{
                job()
            }

            TextField{
                width:key.width
                height:key.height
                visible:false
                id:key_text
                anchors.left:parent.right
                text:"enter your key here"

            }
        }
        
    }

}
