#include <QApplication>
#include <QQmlApplicationEngine>


int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QApplication::setOrganizationName(QStringLiteral("sysdvr-qt"));
    QApplication::setApplicationName(QStringLiteral("sysdvr-qt"));
    QApplication::setDesktopFileName(QStringLiteral("io.github.parnassius.SysDVR-Qt"));

    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    engine.load(url);

    return app.exec();
}
