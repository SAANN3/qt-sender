import QtQuick
import QtQuick.Controls
import QtQml
import filesforsend_class 1.0

Item {
    Filesforsend_class{
        id:file_class
    }
    property int recieve:idorecieve
    property int height1:100
    property real percentage:0.01
    property int completed:0
    property string status
    id:itemr
    objectName: "itemrr"
    width:mainwin.width
    height:height1
    Component.onCompleted:{
        if(recieve==0){file_class.recieveObj(itemr);net.sendFile(device,file,file_class);status = "downloading"

        }
        if(recieve==1){file_class.recieveObj(itemr);net.sendFile(device,file,file_class,1);status = "recieving"

        }
    }
    Rectangle {

                //width:mainwin.width
                width:parent.width
                height: parent.height
                color:Material.primary
                radius:25
                border.color:Qt.lighter(Material.primary,0.9)
                border.width:2
                Text{
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins:parent.width*0.05
                    anchors.topMargin: parent.height/6
                    color:Material.foreground
                    text:file

                }
                Text{
                    id:topc
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: progress.top
                    anchors.topMargin: parent.height/5
                    color:Material.foreground
                    text:device

                }
                Text{
                    id:stat
                    anchors.left:parent.left
                    text:status
                    anchors.margins:parent.width*0.05
                    anchors.top:progress.top
                    anchors.topMargin: parent.height/5
                    color:Material.foreground
                }

                ProgressBar{
                    id:progress
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins:parent.width*0.05
                    value: 0
                    width: parent.width*0.9
                    height: parent.height/6
                    anchors.topMargin: parent.height/2
                    padding:2
                    background: Rectangle {
                            implicitWidth: progress.width
                            implicitHeight: progress.height
                            color: Material.background
                            border.color:Material.foreground
                            radius: 10
                        }

                        contentItem: Item {
                            implicitWidth: progress.width
                            implicitHeight: progress.height*0.6
                            Rectangle{
                                clip:true
                                color:Material.foreground
                                width:parent.width*percentage
                                height:parent.height
                            }
                        }


                }

              }

}
