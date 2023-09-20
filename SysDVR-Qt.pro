QT += \
    quick \
    widgets

TARGET = sysdvr-qt

SOURCES += \
    src/main.cpp \
    src/sysdvr.cpp

HEADERS += \
    src/sysdvr.h

RESOURCES += src/qml.qrc

isEmpty(SYSDVR_CLIENT_EXECUTABLE): SYSDVR_CLIENT_EXECUTABLE = SysDVR-Client
DEFINES += SYSDVR_CLIENT_EXECUTABLE=\\\"$$SYSDVR_CLIENT_EXECUTABLE\\\"

isEmpty(PREFIX): PREFIX = /usr/local

target.path = $$PREFIX/bin
INSTALLS += target

desktop.path = $$PREFIX/share/applications
desktop.files += io.github.parnassius.SysDVR-Qt.desktop
INSTALLS += desktop

metainfo.path = $$PREFIX/share/metainfo
metainfo.files += io.github.parnassius.SysDVR-Qt.metainfo.xml
INSTALLS += metainfo

icon.path = $$PREFIX/share/icons/hicolor/scalable/apps
icon.files += io.github.parnassius.SysDVR-Qt.svg
INSTALLS += icon
