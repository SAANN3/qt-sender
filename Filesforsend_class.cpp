#include "Filesforsend_class.h"
#include <QVariant>
Filesforsend_class::Filesforsend_class()
{

}

void Filesforsend_class::setSize(quint64 num)
{
   maxSize = num;
}

void Filesforsend_class::checkSize()
{
    float val = (float)recievedSize/(float)maxSize;
    val = std::roundf(val*100)/100;
    QVariant percentage = val;
    obj->setProperty("percentage",percentage);
}

void Filesforsend_class::recieveStatus(int num)
{
       QString job;
       if(num==1){
           job = "completed";
       }
       if(num==2){
           job = "aborted";
       }
       obj->setProperty("status",job);
       this->disconnect();
       this->deleteLater();

}

void Filesforsend_class::recieveHowMuchRecieved(quint64 num)
{
    recievedSize = num;
    this->checkSize();
}
Filesforsend_class* Filesforsend_class::returnPointer()
{
    return this;
}

void Filesforsend_class::recieveObj(QObject *obj1)
{
    obj = obj1;
}
