#include <QApplication>
#include <QFontDatabase>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "sysdvr.h"


int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QApplication::setOrganizationName("sysdvr-qt");
    QApplication::setApplicationName("sysdvr-qt");
    QApplication::setDesktopFileName("io.github.parnassius.SysDVR-Qt");

    SysDVR sysdvr;
    const QFont fixedFont = QFontDatabase::systemFont(QFontDatabase::FixedFont);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("sysdvr", &sysdvr);
    engine.rootContext()->setContextProperty("fixedFont", fixedFont);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    engine.load(url);

    return app.exec();
}
