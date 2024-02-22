QT += \
    quick \
    widgets

CONFIG += qmltypes

QML_IMPORT_NAME = SysDVR
QML_IMPORT_MAJOR_VERSION = 1

TARGET = sysdvr-qt

INCLUDEPATH += ./src

SOURCES += \
    src/main.cpp \
    src/sysdvr.cpp

HEADERS += \
    src/sysdvr.h

RESOURCES += src/qml.qrc

DEFINES += \
    QT_NO_CAST_TO_ASCII \
    QT_NO_CAST_FROM_ASCII \
    QT_NO_URL_CAST_FROM_STRING \
    QT_NO_CAST_FROM_BYTEARRAY \

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
