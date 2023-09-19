#include "sysdvr.h"


SysDVR::SysDVR(QObject *parent) : QObject(parent) {
    process.setProgram("SysDVR-Client");
    connect(&process, SIGNAL(started()), this, SLOT(processStarted()));
    connect(&process, SIGNAL(finished(int)), this, SLOT(processFinished()));
    connect(&process, SIGNAL(readyReadStandardOutput()), this, SLOT(processStdOut()));
    connect(&process, SIGNAL(readyReadStandardError()), this, SLOT(processStdErr()));
}

void SysDVR::loadVersion() {
    process.setArguments({"--version"});
    process.start();
    if (!process.waitForFinished(2500)) {
        process.terminate();
    }
}

void SysDVR::start(QString channels, QString source, QString ipAddress, QString customTitle, bool fullscreen) {
    QStringList args = {};
    if (source == "usb") {
        args << "usb";
    } else {
        args << "bridge" << ipAddress;
    }
    if (channels == "video") {
        args << "--no-audio";
    } else if (channels == "audio") {
        args << "--no-video";
    }
    if (!customTitle.isEmpty()) {
        args << "--title" << customTitle;
    }
    if (fullscreen) {
        args << "--fullscreen";
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

void SysDVR::processStdOut() {
    emit message(process.readAllStandardOutput());
}

void SysDVR::processStdErr() {
    emit message(process.readAllStandardError());
}
