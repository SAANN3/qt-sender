#ifndef NETWORK_H
#define NETWORK_H


#include <QObject>
#include <QTcpSocket>
#include <QTcpServer>
#include <QJSValue>
#include <QThread>
#include <QQmlApplicationEngine>
#include <thread_for_network.h>
#include <Filesforsend_class.h>
class Network : public QTcpServer
{
    Q_OBJECT
    Q_PROPERTY(QString Get_serverIp READ Get_serverIp CONSTANT)
    Q_PROPERTY(QStringList Get_listIp READ Get_listIp CONSTANT)

public:
    Q_INVOKABLE void tryToConnect(QString ip,QString port,QString key);
    Q_INVOKABLE void set_key(int num,QString key);
    Q_INVOKABLE void sendFile(QString ip,QString filepath,Filesforsend_class* pointer,int num = 0);
    Network();
    QString Get_serverIp();
public slots:
    void compare_keys(QString key);
    void blockButton(int num);
    void addIp(QString ip,int ver);
    void connection();
    void emitAppendToModel(QString ip,QString filepath);
private:
    QString key_storage;
    void incomingConnection(qintptr handle) override;
    QStringList Get_listIp();
    QList<Thread_for_network*> listThreads;
    QList<QString> whichBlocked;
    QList<QString> listIp;
    QString address;
signals:
    void key_differ();
    void appendToModel(QString ip,QString filepath);
    void readyToRecieveIp();
    void threadWork(QString ip);
};


#endif // NETWORK_H
