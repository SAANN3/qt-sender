#ifndef THREAD_FOR_NETWORK_H
#define THREAD_FOR_NETWORK_H

#include <QObject>
#include <QTcpSocket>
#include <QThread>
#include <QFile>
#include <QSize>
class Thread_for_network: public QThread
{
    Q_OBJECT
    void run() override;
public:
    Thread_for_network(int work1,quintptr description1,QString ip1 = NULL, quint16 port1 = NULL,QString key = NULL);
public slots:
    void sendIp();
    void acceptSend(QString file_path);
    void removeIp();
private slots:

    void readyToRead();
private:
    bool first_check = true;
    QString address;
    QByteArray bytearray;
    bool error_occured = false;
    QTcpSocket* socket;
    int stage = 0;
    qsizetype size = 0;
    QFile file;
    int work;
    quintptr description;
    QString ip;
    quint16 port;
    QString key_storage;
signals:
    void check_key(QString key);
    void blockButton(int num);
    void waitForStart();
    void sendMaxSize(quint64 num);
    void sendToAppend(QString ip,QString file_name);
    void sendStatus(int num);
    void sendSizeRecievedBytes(quint64 num);
    void connectedIp(QString ip,int ver);
    void removeConnectedIp(QString ip,int ver);
};

#endif // THREAD_FOR_NETWORK_H

