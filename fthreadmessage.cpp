#include "fthreadmessage.h"

#include <QDebug>

FThreadMessage::FThreadMessage(const QString &mt, QObject *parent)
    : QObject{parent}
{
    messagetext = mt;
}

FThreadMessage::~FThreadMessage()
{

}

void FThreadMessage::run()
{
    //qInfo() << QThread::currentThread();
    QThread::currentThread()->msleep(500);
    emit sendMessage(messagetext);
}
