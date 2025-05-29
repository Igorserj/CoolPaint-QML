#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QtGlobal>
#include "fileio.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("CoolPaint");
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QQuickWindow::setSceneGraphBackend(QSGRendererInterface::OpenGL);
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Register the FileIO type for QML
    qmlRegisterType<FileIO>("Coolpaint", 1, 0, "FileIO");

    engine.rootContext()->setContextProperty("baseDir", QGuiApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("version", qVersion());
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
    qputenv("QML_XHR_ALLOW_FILE_WRITE", QByteArray("1"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.load(url);
    return app.exec();
}
