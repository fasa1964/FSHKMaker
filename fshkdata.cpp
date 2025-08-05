#include "fshkdata.h"

#include <QSettings>
#include <QTimer>
#include <QMapIterator>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QImage>
#include <QImageWriter>
#include <QImageReader>

#include <qguiapplication.h>
#include "fthreadmessage.h"

FSHKData::FSHKData(QObject *parent)
    : QObject{parent}
{

    //qInfo() << QThread::currentThread();
    setLogedIn(false);
    setFirstname("");
    setLastname("");
    setKlass("");
    setKlassIndex(-1);

    readSettings();
}

FSHKData::~FSHKData()
{

}

void FSHKData::saveData(const QVariantMap &vmap)
{
    qDebug() << vmap.value("question").toString();
    qDebug() << vmap.value("answerA").toString();
    qDebug() << vmap.value("answerB").toString();
    qDebug() << vmap.value("answerC").toString();
    qDebug() << vmap.value("answerD").toString();
    qDebug() << vmap.value("statusA").toBool();
    qDebug() << vmap.value("statusB").toBool();
    qDebug() << vmap.value("statusC").toBool();
    qDebug() << vmap.value("statusD").toBool();
    qDebug() << vmap.value("imageA").toUrl();
    qDebug() << vmap.value("imageB").toUrl();
    qDebug() << vmap.value("imageC").toUrl();
    qDebug() << vmap.value("imageD").toUrl();
    qDebug() << vmap.value("imageQ").toUrl();

    QJsonObject json_obj;

    QVariantMap map = vmap;
    QMapIterator<QString, QVariant> it(vmap);
    while (it.hasNext()) {

        it.next();
        QString key = it.key();
        QVariant var = it.value();

        json_obj.insert(key, var.toJsonValue());

    }



    qDebug() << json_obj;

}


void FSHKData::setLoginData(const QVariantMap &vmap)
{

    setFirstname(vmap.value("firstname").toString());
    setLastname(vmap.value("lastname").toString());
    setKlass(vmap.value("klass").toString());
    setKlassIndex(vmap.value("index").toInt());
    saveSettings();
}

QString FSHKData::infoText()
{
    QString info;
    info = tr("This app is created to writing quiz questions with 4 possible answers. "
        "It is also possible to add pictures for each answers or question, by clicking on the + Button. "
        "The CheckBox beside the Text: Answers A..D is for marking when the answer is correct. "
        "At least one correct answer has to be marked.\n"
        "The Save-Button will save the data's on your device.\n"
        "The Change-Button will load the data's to change the text."
        "The Sent-Button will open a cloud in a browser for copying the data's into the cloud!"
        "The Login-Button open a dialog to login!");

    return info;
}

bool FSHKData::sslsupport()
{
    bool status = false;
    status = QSslSocket::supportsSsl();
    return status;
}

bool FSHKData::online()
{
    bool status = false;

    QNetworkAccessManager manager;
    QNetworkRequest request( QUrl("http://www.google.com") );
    QNetworkReply *inforeply = manager.get(request);

    QEventLoop loop;
    QTimer timeoutTimer;

    connect(&timeoutTimer, &QTimer::timeout, &loop, &QEventLoop::quit );
    connect(inforeply, &QNetworkReply::finished , &loop, &QEventLoop::quit );

    timeoutTimer.setSingleShot(true);
    timeoutTimer.start(3000);

    loop.exec();

    if (inforeply->error() == QNetworkReply::NoError){
        qint64 array = inforeply->bytesAvailable();
        QString str = QString::number(array);
        if(!str.isEmpty())
            status = true;
    }else{
        status = false;
        prepareMessage(tr("Network-Error:") + inforeply->errorString() );
    }

    inforeply->deleteLater();

    return status;
}

bool FSHKData::logedIn() const
{
    return m_logedIn;
}

void FSHKData::setLogedIn(bool newLogedIn)
{
    if (m_logedIn == newLogedIn)
        return;
    m_logedIn = newLogedIn;
    emit logedInChanged();
}

QString FSHKData::firstname() const
{
    return m_firstname;
}

void FSHKData::setFirstname(const QString &newFirstname)
{
    if (m_firstname == newFirstname)
        return;
    m_firstname = newFirstname;
    emit firstnameChanged();
}

QString FSHKData::lastname() const
{
    return m_lastname;
}

void FSHKData::setLastname(const QString &newLastname)
{
    if (m_lastname == newLastname)
        return;
    m_lastname = newLastname;
    emit lastnameChanged();
}

QString FSHKData::klass() const
{
    return m_klass;
}

void FSHKData::setKlass(const QString &newKlass)
{
    if (m_klass == newKlass)
        return;
    m_klass = newKlass;
    emit klassChanged();
}

int FSHKData::klassIndex() const
{
    return m_klassIndex;
}

void FSHKData::setKlassIndex(int newKlassIndex)
{
    if (m_klassIndex == newKlassIndex)
        return;
    m_klassIndex = newKlassIndex;
    emit klassIndexChanged();
}

void FSHKData::threadFinished()
{

}

void FSHKData::receivedMessage(const QString &text)
{
    emit sendInfoMessage(text);
}

void FSHKData::prepareMessage(const QString &text)
{
    FThreadMessage *thread = new FThreadMessage(text);
    if( !thread ){
        sendInfoMessage("Error: Thread failed");
        return;
    }

    connect(thread, &FThreadMessage::finished, this, &FSHKData::threadFinished);
    connect(thread, &FThreadMessage::sendMessage, this, &FSHKData::receivedMessage);

    thread->setAutoDelete(true);
    QThreadPool::globalInstance()->start(thread);
}

void FSHKData::readSettings()
{
    QSettings settings(qGuiApp->organizationName(), qGuiApp->applicationName()+qGuiApp->applicationVersion());

    QString fname = settings.value("firstname", "").toString();
    QString lname = settings.value("lastname", "").toString();
    QString cl = settings.value("klass", "").toString();
    int index = settings.value("klassindex", -1).toInt();

    if(fname.isEmpty() || lname.isEmpty() || cl.isEmpty() || index == -1 ){
        prepareMessage(tr("Please loging before starting!"));
        //emit sendInfoMessage(tr("Please loging before starting!"));
        return;
    }

    setFirstname(fname);
    setLastname(lname);
    setKlass(cl);
    setKlassIndex(index);
}

void FSHKData::saveSettings()
{
    QSettings settings(qGuiApp->organizationName(), qGuiApp->applicationName()+qGuiApp->applicationVersion());

    settings.setValue("firstname", firstname());
    settings.setValue("lastname", lastname());
    settings.setValue("klass", klass() );
    settings.setValue("klassindex", klassIndex());
}
