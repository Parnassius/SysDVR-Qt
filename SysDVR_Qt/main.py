import sys
from pathlib import Path

from PyQt5.QtCore import QObject, QProcess, pyqtSignal, pyqtSlot
from PyQt5.QtGui import QFontDatabase
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication


class SysDVR(QObject):
    message = pyqtSignal(str)
    stateChanged = pyqtSignal(bool)

    process = QProcess()

    def __init__(self):
        super().__init__()
        self.process.setProgram("SysDVR-Client")
        self.process.started.connect(self.process_started)
        self.process.finished.connect(self.process_finished)
        self.process.readyReadStandardOutput.connect(self.process_stdout)
        self.process.readyReadStandardError.connect(self.process_stderr)

    @pyqtSlot(str, str, str, bool)
    def start(self, channels, source, ip_address, fullscreen):
        args = []
        if source == "usb":
            args.append("usb")
        else:
            args.append("bridge")
            args.append(ip_address)
        if channels == "video":
            args.append("--no-audio")
        elif channels == "audio":
            args.append("--no-video")
        if fullscreen:
            args.append("--fullscreen")
        self.process.setArguments(args)
        self.process.start()

    @pyqtSlot()
    def terminate(self):
        self.process.terminate()

    def process_started(self):
        self.stateChanged.emit(True)

    def process_finished(self):
        self.stateChanged.emit(False)

    def process_stdout(self):
        data = self.process.readAllStandardOutput()
        stdout = bytes(data).decode("utf8")
        self.message.emit(stdout)

    def process_stderr(self):
        data = self.process.readAllStandardError()
        stderr = bytes(data).decode("utf8")
        self.message.emit(stderr)


def main():
    def cleanup():
        sysdvr.terminate()
        sysdvr.process.waitForFinished(1000)
        app.quit()

    app = QApplication(sys.argv)
    app.setOrganizationName("sysdvr-qt")
    app.setApplicationName("sysdvr-qt")
    app.setDesktopFileName("io.github.parnassius.SysDVR-Qt")
    app.setQuitOnLastWindowClosed(False)
    app.lastWindowClosed.connect(cleanup)

    sysdvr = SysDVR()
    fixedFont = QFontDatabase.systemFont(QFontDatabase.FixedFont)

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("sysdvr", sysdvr)
    engine.rootContext().setContextProperty("fixedFont", fixedFont)
    engine.load(str(Path(__file__).parent / "main.qml"))
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
