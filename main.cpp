#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <Network.h>
#include <Filesforsend_class.h>
#include <QQuickStyle>
#include <QQmlContext>
#include <QDir>
#include <QStandardPaths>и
int main(int argc, char *argv[])
{
    QDir::setCurrent(QStandardPaths::writableLocation(QStandardPaths::DownloadLocation));
    qDebug() << QDir::currentPath();
    QGuiApplication app(argc, argv);
    QThread::currentThread()->setPriority(QThread::HighPriority);
    QQuickStyle::setStyle("Material");
    QQmlApplicationEngine engine;
    QQmlContext* context = engine.rootContext();
    Network network;
    context->setContextProperty("net",&network);
    qmlRegisterType<Filesforsend_class>("filesforsend_class",1,0,"Filesforsend_class");
    const QUrl url(u"qrc:/sender/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
