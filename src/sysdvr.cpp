#include "sysdvr.h"

#include <QSettings>


SysDVR::SysDVR(QObject *parent) : QObject(parent) {
    process.setProgram(QStringLiteral(SYSDVR_CLIENT_EXECUTABLE));
    connect(&process, SIGNAL(started()), this, SLOT(processStarted()));
    connect(&process, SIGNAL(finished(int)), this, SLOT(processFinished()));
}

void SysDVR::start() {
    const QSettings settings;
    const QString channel = settings.value(QStringLiteral("channel")).toString();
    const QString source = settings.value(QStringLiteral("source")).toString();
    const QString ipAddress = settings.value(QStringLiteral("ipAddress")).toString();
    const bool useCustomTitle = settings.value(QStringLiteral("useCustomTitle")).toBool();
    const QString customTitle = useCustomTitle ? settings.value(QStringLiteral("customTitle")).toString() : QString();
    const bool fullscreen = settings.value(QStringLiteral("fullscreen")).toBool();

    QStringList args = {};
    if (source == QLatin1String("usb")) {
        args << QStringLiteral("usb");
    } else {
        args << QStringLiteral("bridge");
        if (!ipAddress.isEmpty()) {
            args << ipAddress;
        }
    }
    if (channel == QLatin1String("video")) {
        args << QStringLiteral("--no-audio");
    } else if (channel == QLatin1String("audio")) {
        args << QStringLiteral("--no-video");
    }
    if (!customTitle.isEmpty()) {
        args << QStringLiteral("--title") << customTitle;
    }
    if (fullscreen) {
        args << QStringLiteral("--fullscreen");
    }
    process.setArguments(args);
    process.start();
}

void SysDVR::terminate() {
    process.terminate();
}

void SysDVR::cleanup() {
    process.terminate();
    process.waitForFinished(1000);
}

void SysDVR::processStarted() {
    emit stateChanged(true);
}

void SysDVR::processFinished() {
    emit stateChanged(false);
}
