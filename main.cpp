#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

#include "fshkdata.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("FSHKMaker");
    app.setApplicationVersion("1.0");
    app.setOrganizationName("fshkmaker@fasasoft");
    app.setWindowIcon(QIcon(":/questmaker.ico"));

    qmlRegisterType<FSHKData>("FSHKData", 1,0, "FData");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("FSHKMaker", "Main");

    return app.exec();
}
