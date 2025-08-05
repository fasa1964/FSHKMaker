#ifndef FSHKDATA_H
#define FSHKDATA_H

#include <QObject>
#include <QQmlEngine>

#include <QSsl>
#include <QSslError>
#include <QSslSocket>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

#include <QVariantMap>

class FSHKData : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool logedIn READ logedIn WRITE setLogedIn NOTIFY logedInChanged FINAL)
    Q_PROPERTY(QString firstname READ firstname WRITE setFirstname NOTIFY firstnameChanged FINAL)
    Q_PROPERTY(QString lastname READ lastname WRITE setLastname NOTIFY lastnameChanged FINAL)
    Q_PROPERTY(QString klass READ klass WRITE setKlass NOTIFY klassChanged FINAL)
    Q_PROPERTY(int klassIndex READ klassIndex WRITE setKlassIndex NOTIFY klassIndexChanged FINAL)

public:
    explicit FSHKData(QObject *parent = nullptr);
    ~FSHKData();

    Q_INVOKABLE void saveData(const QVariantMap &vmap);
    Q_INVOKABLE void setLoginData(const QVariantMap &vmap);
    Q_INVOKABLE QString infoText();
    Q_INVOKABLE bool sslsupport();
    Q_INVOKABLE bool online();

    bool logedIn() const;
    void setLogedIn(bool newLogedIn);

    QString firstname() const;
    void setFirstname(const QString &newFirstname);

    QString lastname() const;
    void setLastname(const QString &newLastname);

    QString klass() const;
    void setKlass(const QString &newKlass);

    int klassIndex() const;
    void setKlassIndex(int newKlassIndex);

signals:

    void sendInfoMessage(const QString &messagetext);

    void logedInChanged();
    void firstnameChanged();
    void lastnameChanged();
    void klassChanged();
    void klassIndexChanged();


private slots:
    void threadFinished();
    void receivedMessage(const QString &text);

private:
    bool m_logedIn;
    QString m_firstname;
    QString m_lastname;
    QString m_klass;
    int m_klassIndex;

    void prepareMessage(const QString &text);

    void readSettings();
    void saveSettings();

};

#endif // FSHKDATA_H
