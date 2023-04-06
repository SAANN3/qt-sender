#include "Network.h"
#include "thread_for_network.h"
#include <QTcpSocket>
#include <QTcpServer>
#include <QNetworkInterface>
#include <QIODevice>
#include <QVariant>
#include <QJSValue>
#include <QFile>
#include <QUrl>
#include <QFileInfo>
#include <QQmlProperty>
Network::Network()
    {
    //get local ip
    foreach (const QNetworkInterface &netInterface, QNetworkInterface::allInterfaces()) {
        QNetworkInterface::InterfaceFlags flags = netInterface.flags();
        if( (bool)(flags & QNetworkInterface::IsRunning) && !(bool)(flags & QNetworkInterface::IsLoopBack)){
            foreach (const QNetworkAddressEntry &myaddress, netInterface.addressEntries()) {
                if(myaddress.ip().protocol() == QAbstractSocket::IPv4Protocol)
                    address =  myaddress.ip().toString();break;
                qDebug() << address;
                break;
            }
        }
    }

    // listen port
    int tmp_port = 35440;
    while(!this->listen(QHostAddress(address),tmp_port)&&tmp_port<=35450)
    {
        tmp_port +=1;
        qDebug() << "CRITICAL::" << this->errorString();
    }
    connect(this,SIGNAL(newConnection()),this,SLOT(connection()));
}
void Network::connection()
{
    this->nextPendingConnection();

}
void Network::emitAppendToModel(QString ip, QString filepath)
{
    emit appendToModel(ip,filepath);
}

QString Network::Get_serverIp()
{
    return address + " : " + QString::number(this->serverPort(),10);
}

void Network::compare_keys(QString key)
{
    if(!key_storage.isEmpty()){
    qDebug()<<key_storage<< " = "<< key;
    if(key_storage == key){return;}
    else{emit key_differ();qDebug() << "differ";}
    }
}

QStringList Network::Get_listIp()
{
    QStringList list;
    for(int i = 0;i<listIp.size();i++)
    {
        list.append(whichBlocked[i] + listIp[i]);
    }
    return list;
}

void Network::incomingConnection(qintptr handle)
{
    Thread_for_network *thread = new Thread_for_network(0,handle);
    thread->start();
    thread->moveToThread(thread);
    listThreads.append(thread);
    connect(this,&Network::key_differ,thread,&Thread_for_network::removeIp);
    connect(thread,&Thread_for_network::check_key,this,&Network::compare_keys);
    connect(thread,&Thread_for_network::connectedIp,this,&Network::addIp);
    connect(thread,&Thread_for_network::sendToAppend,this,&Network::emitAppendToModel);
    connect(thread,&Thread_for_network::removeConnectedIp,this,&Network::addIp);
    connect(thread,&Thread_for_network::blockButton,this,&Network::blockButton);
    connect(this,&Network::readyToRecieveIp,thread,&Thread_for_network::sendIp);
    connect(thread,&Thread_for_network::waitForStart,this,&Network::readyToRecieveIp);

}
void Network::addIp(QString ip,int ver)
{
  switch(ver)
  {
    case 1:
      listIp.append(ip);
      whichBlocked.append("|W|");
      disconnect(this,&Network::readyToRecieveIp,listThreads[listThreads.indexOf(sender())],&Thread_for_network::sendIp);
      break;
    case 2:
      for(int i =0;i<listIp.size();i++)
      {
        if(listThreads[i]==sender())
        {
            listThreads.remove(i);
            break;
        }
      }
      whichBlocked.remove(listIp.indexOf(ip));
      listIp.remove(listIp.indexOf(ip));
      break;

  }
}
void Network::sendFile(QString ip,QString filepath,Filesforsend_class* pointer, int num)
{
    connect(this,&Network::threadWork,listThreads[listIp.indexOf(ip)],&Thread_for_network::acceptSend);
    connect(listThreads[listIp.indexOf(ip)],&Thread_for_network::sendSizeRecievedBytes,pointer,&Filesforsend_class::recieveHowMuchRecieved);
    connect(listThreads[listIp.indexOf(ip)],&Thread_for_network::sendStatus,pointer,&Filesforsend_class::recieveStatus);
    connect(listThreads[listIp.indexOf(ip)],&Thread_for_network::sendMaxSize,pointer,&Filesforsend_class::setSize);
    if(num == 0)
    {
            emit threadWork(filepath);
    }

    disconnect(this,&Network::threadWork,listThreads[listIp.indexOf(ip)],&Thread_for_network::acceptSend);

}
void Network::tryToConnect(QString ip,QString port,QString key = NULL)
{

    quint16 quintport = port.toUShort();
    Thread_for_network *thread;
    if(!key.isEmpty()){
    thread = new Thread_for_network(1,NULL,ip,quintport,key);
    }
    else{
    thread = new Thread_for_network(1,NULL,ip,quintport);
    }
    thread->start();
    thread->moveToThread(thread);
    connect(this,&Network::key_differ,thread,&Thread_for_network::removeIp);
    connect(thread,&Thread_for_network::check_key,this,&Network::compare_keys);
    connect(thread,&Thread_for_network::blockButton,this,&Network::blockButton);
    connect(thread,&Thread_for_network::connectedIp,this,&Network::addIp);
    connect(thread,&Thread_for_network::sendToAppend,this,&Network::emitAppendToModel);
    connect(thread,&Thread_for_network::removeConnectedIp,this,&Network::addIp);
    connect(thread,&Thread_for_network::waitForStart,this,&Network::readyToRecieveIp);
    connect(this,&Network::readyToRecieveIp,thread,&Thread_for_network::sendIp);
    listThreads.append(thread);
}

void Network::set_key(int num, QString key)
{
    if(num==1){key_storage = key;}
    if(num==0){key_storage = NULL;}
    qDebug()<< key_storage;
}
void Network::blockButton(int num)
{
    int i = listThreads.indexOf(sender());
    if(num==0)
    {
         whichBlocked[i] = "|D|";
    }
    if(num==1)
    {
        whichBlocked[i] = "|W|";

    }
}
