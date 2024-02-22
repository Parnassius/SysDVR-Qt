#ifndef SYSDVR_H
#define SYSDVR_H

#include <QProcess>
#include <QQmlEngine>


class SysDVR : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit SysDVR(QObject *parent = nullptr);
    Q_INVOKABLE void start();
    Q_INVOKABLE void terminate();
    Q_INVOKABLE void cleanup();

signals:
    void stateChanged(bool running);

private slots:
    void processStarted();
    void processFinished();

private:
    QProcess process;
};

#endif // SYSDVR_H
