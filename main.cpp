#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QSGRendererInterface>
#include <QDebug>
#include "fileio.h"

int main(int argc, char *argv[])
{
    // Set environment variables BEFORE QApplication is created
    qputenv("QSG_RENDER_LOOP", "threaded");
    qputenv("QT_QUICK_BACKENDS", "opengl");

    // High DPI scaling
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

// Check Qt version and set backend appropriately
#if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
    QQuickWindow::setSceneGraphBackend(QSGRendererInterface::OpenGL);
    // QQuickWindow::setSceneGraphBackend(QSGRendererInterface::Software);
#else
    QQuickWindow::setSceneGraphBackend("opengl");
#endif

    // Debug what backend was set
    qDebug() << "Requested SceneGraph backend:" << QQuickWindow::sceneGraphBackend();

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Rest of your initialization code
    qmlRegisterType<FileIO>("Coolpaint", 1, 0, "FileIO");
    engine.rootContext()->setContextProperty("baseDir", QGuiApplication::applicationDirPath());

    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
    qputenv("QML_XHR_ALLOW_FILE_WRITE", QByteArray("1"));

    const QUrl url(QStringLiteral("qrc:/main.qml"));
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

    // This might show a different value than above because the engine might have changed it
    qDebug() << "Active SceneGraph backend after engine load:" << QQuickWindow::sceneGraphBackend();

    return app.exec();
}
