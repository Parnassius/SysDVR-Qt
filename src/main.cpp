#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "sysdvr.h"


int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QApplication::setOrganizationName(QStringLiteral("sysdvr-qt"));
    QApplication::setApplicationName(QStringLiteral("sysdvr-qt"));
    QApplication::setDesktopFileName(QStringLiteral("io.github.parnassius.SysDVR-Qt"));

    SysDVR sysdvr;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("sysdvr"), &sysdvr);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    engine.load(url);

    return app.exec();
}
