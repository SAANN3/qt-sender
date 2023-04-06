#ifndef FILESFORSEND_CLASS_H
#define FILESFORSEND_CLASS_H

#include <QObject>

class Filesforsend_class: public QObject
{
    Q_OBJECT
public:
    Filesforsend_class();
    void checkSize();
    Filesforsend_class* returnPointer();
    Q_PROPERTY(Filesforsend_class* returnPointer READ returnPointer CONSTANT)
    Q_INVOKABLE void recieveObj(QObject* obj1);
signals:
    void setStatus(int num);
public slots:
    void recieveStatus(int num);
    void recieveHowMuchRecieved(quint64 num);
    void setSize(quint64 num);
private:
    QObject* obj;
    quint64 maxSize;
    quint64 recievedSize;
};

#endif // FILESFORSEND_CLASS_H
