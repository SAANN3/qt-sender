#include "thread_for_network.h"
#include <QTcpSocket>
#include <QFile>
#include <QUrl>
#include <QFileInfo>
#include <QQmlFile>

Thread_for_network::Thread_for_network(int work1,quintptr description1,QString ip1,quint16 port1,QString key){
    if(!key.isEmpty()){
        key_storage = key;
    }
    work = work1;
    description = description1;
    ip = ip1;
    port = port1;
}
void Thread_for_network::run()
{
    if(work==0){
    socket = new QTcpSocket();
    connect(socket,SIGNAL(readyRead()),this,SLOT(readyToRead()));
    connect(socket,SIGNAL(disconnected()),this,SLOT(removeIp()));
    socket->setSocketDescriptor(description);
    emit waitForStart();
    if(!socket->waitForReadyRead()){
        socket->abort();
    }
    }
    if(work==1){
        socket = new QTcpSocket();
        connect(socket,SIGNAL(readyRead()),this,SLOT(readyToRead()));
        connect(socket,SIGNAL(disconnected()),this,SLOT(removeIp()));
        socket->connectToHost(ip,port);
        if(!socket->waitForConnected()){
            error_occured = true;
        }
        emit waitForStart();
    }
    address = socket->peerAddress().toString()+":"+QString::number(socket->peerPort());

    exec();
}
void Thread_for_network::readyToRead()
{
    bytearray = socket->readAll();
    if(first_check==true){
        QString key = bytearray;
        emit check_key(key);
        first_check=false;
        return;
    }
    switch(stage){
        case 0:{
                emit blockButton(0);
                int i = 1;
                QString name = bytearray.first(bytearray.indexOf("\n"));
                bytearray = bytearray.sliced(bytearray.indexOf("\n")+1);
                file.setFileName(name);
                emit sendToAppend(address,file.fileName());
                QString propertyname = name;;
                while(file.exists())
                {
                    name = propertyname.insert(propertyname.indexOf('.'),QString("(" + QString::number(i) + ")"));
                    file.setFileName(name);
                    i++;
                }
                file.open(QIODeviceBase::NewOnly);
                stage++;
                if(!bytearray.isEmpty())
                {
                    goto case1;
                }
                break;}
        case 1:{
                size = QString(socket->readAll()).toLongLong();
                emit sendMaxSize(size);
                case1:
                    size = bytearray.first(bytearray.indexOf("\n")).toLongLong();
                    qDebug()<<size;
                    bytearray = bytearray.sliced(bytearray.indexOf("\n")+1);
                    emit sendMaxSize(size);
                    if(!bytearray.isEmpty())
                    {
                        stage++;
                        goto case2;
                    }
                stage++;
                break;}
        case 2:{
                if(file.size()<size)
                {
                    file.write(socket->readAll());
                    emit sendSizeRecievedBytes(file.size());
                }
                if(file.size()>=size){
                    file.close();
                    emit sendStatus(1);
                    emit blockButton(1);
                    stage = 0;

                }
                case2:{
                    if(file.size()<size)
                      {
                      file.write(bytearray);
                      emit sendMaxSize(size);
                      emit sendSizeRecievedBytes(file.size());
                      }
                    if(file.size()>=size){
                        file.close();
                        emit sendStatus(1);
                        emit blockButton(1);
                        stage = 0;
                    }}

                break;}
    }

}
void Thread_for_network::sendIp()
{
    emit connectedIp(address,1);
    if(error_occured)
    {
        emit removeConnectedIp(address,2);
    }
    else{
    if(work==1){
    if(key_storage.isEmpty()){key_storage="0";}
    socket->write(key_storage.toUtf8());
    first_check=false;
    socket->waitForBytesWritten();
    }}

}
void Thread_for_network::removeIp()
{
    emit sendStatus(2);
    emit removeConnectedIp(address,2);
    disconnect(socket,SIGNAL(disconnected()),this,SLOT(removeIp()));
    this->exit(0);
    socket->abort();

}
void Thread_for_network::acceptSend(QString file_path)
{
    //emit blockButton(0);
    QString filepath = QUrl(file_path).toLocalFile();

    #ifdef Q_OS_ANDROID
    QFile file(file_path);
    #else
    QFile file(filepath);
    #endif
    file.open(QIODevice::ReadOnly);
    emit sendMaxSize(file.size());
    QFileInfo fileinfo(file);
    QByteArray data;
    #ifdef Q_OS_ANDROID
    QString temp = fileinfo.fileName().toUtf8()+"\n";
    temp = temp.remove(0,temp.lastIndexOf("%2")+3);
    qDebug() << temp;
    qDebug() << temp.toUtf8();
    socket->write(temp.toUtf8());

    #else
    socket->write(fileinfo.fileName().toUtf8()+"\n");
    #endif
    socket->waitForBytesWritten();

    socket->write(QString::number(file.size()).toUtf8()+"\n");
    quint64 pos = 0;
    while(!file.atEnd())
    {
        data = file.peek(256);
        pos += 256;
        file.seek(pos);
        socket->write(data,256);
        emit sendSizeRecievedBytes(pos);
        if(!socket->waitForBytesWritten()){
            file.close();
            emit sendStatus(2);
            emit blockButton(0);
            return;
        }

        data = 0;
    }
    file.close();
    emit blockButton(1);
   emit sendStatus(1);
}
