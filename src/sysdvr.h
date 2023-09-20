#ifndef SYSDVR_H
#define SYSDVR_H

#include <QProcess>


class SysDVR : public QObject {
    Q_OBJECT

public:
    explicit SysDVR(QObject *parent = nullptr);
    Q_INVOKABLE void loadVersion();
    Q_INVOKABLE void start(QString, QString, QString, QString, bool);
    Q_INVOKABLE void terminate();
    Q_INVOKABLE void cleanup();

signals:
    void message(QString msg);
    void stateChanged(bool running);

private slots:
    void processStarted();
    void processFinished();
    void processStdOut();
    void processStdErr();

private:
    QProcess process;
};

#endif // SYSDVR_H
