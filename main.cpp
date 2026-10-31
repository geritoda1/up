#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle> // <-- 1. ДОБАВИТЬ ЭТОТ INCLUDE
#include "databasemanager.h"
#include "authmanager.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Basic"); // <-- 2. ОТКЛЮЧАЕТ БЕЛЫЕ ЗАСВЕТКИ WINDOWS

    DatabaseManager dbManager;
    AuthManager authManager;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("dbManager", &dbManager);
    engine.rootContext()->setContextProperty("authManager", &authManager);

    const QUrl url(QStringLiteral("qrc:/qt/qml/University/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);
    return app.exec();
}