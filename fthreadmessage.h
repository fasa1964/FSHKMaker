#ifndef FTHREADMESSAGE_H
#define FTHREADMESSAGE_H

#include <QObject>
#include <QRunnable>
#include <QThread>
#include <QThreadPool>

class FThreadMessage : public QObject, public QRunnable
{
    Q_OBJECT
public:
    explicit FThreadMessage(const QString &mt, QObject *parent = nullptr);
    ~FThreadMessage();

    void run() override;

signals:
    void finished();
    void sendMessage(const QString &text);



private:
    QString messagetext;


};

#endif // FTHREADMESSAGE_H
