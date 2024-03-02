#include <QApplication>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QProcess>
#include <QQmlApplicationEngine>


int main(int argc, char *argv[]) {
    if (QFileInfo::exists(QStringLiteral("/.flatpak-info"))) {
        const QDir configDir(qEnvironmentVariable("XDG_CONFIG_HOME"));
        if (!configDir.exists(QStringLiteral("options.json"))) {
            QProcess userDirProcess;

            userDirProcess.start(QStringLiteral("xdg-user-dir"), {QStringLiteral("VIDEOS")});
            userDirProcess.waitForFinished();
            const QString userDirVideo = QString::fromUtf8(userDirProcess.readAllStandardOutput()).trimmed();

            userDirProcess.start(QStringLiteral("xdg-user-dir"), {QStringLiteral("PICTURES")});
            userDirProcess.waitForFinished();
            const QString userDirPictures = QString::fromUtf8(userDirProcess.readAllStandardOutput()).trimmed();

            const QJsonObject optionsObj {
                {QStringLiteral("recordingsPath"), userDirVideo + QStringLiteral("/SysDVR")},
                {QStringLiteral("screenshotsPath"), userDirPictures + QStringLiteral("/SysDVR")}
            };
            const QJsonDocument optionsJson(optionsObj);
            QFile optionsFile(configDir.filePath(QStringLiteral("options.json")));
            optionsFile.open(QFile::WriteOnly);
            optionsFile.write(optionsJson.toJson());
        }
    }

    QApplication app(argc, argv);

    QApplication::setOrganizationName(QStringLiteral("sysdvr-qt"));
    QApplication::setApplicationName(QStringLiteral("sysdvr-qt"));
    QApplication::setDesktopFileName(QStringLiteral("io.github.parnassius.SysDVR-Qt"));

    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    engine.load(url);

    return app.exec();
}
