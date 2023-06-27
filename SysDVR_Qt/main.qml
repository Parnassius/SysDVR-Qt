import Qt.labs.settings 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    minimumWidth: mainPane.width
    maximumWidth: mainPane.width
    minimumHeight: mainPane.height
    maximumHeight: mainPane.height
    title: "SysDVR-Qt"

    Settings {
        id: settings

        property string channel: "both"
        property string source: "usb"
        property alias ipAddress: ipAddress.text
        property alias fullscreen: fullscreen.checked

        function getCheckedButton(group, name) {
            for (let i = 0; i < group.buttons.length; i++) {
                if (group.buttons[i].objectName === name) {
                    return group.buttons[i];
                }
            }
        }
    }

    Connections {
        function onMessage(msg) {
            logTextArea.append(msg);
        }

        function onStateChanged(running) {
            mainSection.enabled = !running;
            if (running) {
                logTextArea.clear();
            }
        }

        target: sysdvr
    }

    FontMetrics {
        id: fontMetrics
        font: fixedFont
    }

    Pane {
        id: mainPane

        RowLayout {
            anchors.fill: parent

            ColumnLayout {
                ColumnLayout {
                    id: mainSection

                    Label {
                        text: qsTr("Channels to stream")
                    }
                    ButtonGroup {
                        id: channels
                        checkedButton: settings.getCheckedButton(this, settings.channel)
                        onClicked: settings.channel = button.objectName
                    }
                    RadioButton {
                        objectName: "video"
                        text: qsTr("Video only")
                        ButtonGroup.group: channels
                    }
                    RadioButton {
                        id: channelsAudioOnly
                        objectName: "audio"
                        text: qsTr("Audio only")
                        ButtonGroup.group: channels
                    }
                    RadioButton {
                        objectName: "both"
                        text: qsTr("Both video and audio")
                        ButtonGroup.group: channels
                    }

                    Label {
                        text: qsTr("Stream source")
                    }
                    ButtonGroup {
                        id: source
                        checkedButton: settings.getCheckedButton(this, settings.source)
                        onClicked: settings.source = button.objectName
                    }
                    RadioButton {
                        id: sourceUSB
                        objectName: "usb"
                        text: qsTr("USB")
                        ButtonGroup.group: source
                    }
                    RadioButton {
                        id: sourceTCPBridge
                        objectName: "bridge"
                        text: qsTr("TCP Bridge")
                        ButtonGroup.group: source
                    }

                    TextField {
                        id: ipAddress
                        placeholderText: qsTr("IP address")
                        enabled: sourceTCPBridge.checked
                        Layout.fillWidth: true
                    }

                    CheckBox {
                        id: fullscreen
                        enabled: !channelsAudioOnly.checked
                        text: qsTr("Start in fullscreen")
                    }
                }

                Button {
                    text: qsTr("Terminate")
                    icon.name: "dialog-cancel"
                    visible: !mainSection.enabled
                    Layout.fillWidth: true
                    onClicked: sysdvr.terminate()
                }
                Button {
                    text: qsTr("Start")
                    icon.name: "media-playback-start"
                    visible: mainSection.enabled
                    enabled: sourceUSB.checked || ipAddress.text
                    Layout.fillWidth: true
                    onClicked: sysdvr.start(settings.channel, settings.source, settings.ipAddress, settings.fullscreen)
                }
            }

            Flickable {
                clip: true
                boundsBehavior: Flickable.DragOverBounds
                flickableDirection: Flickable.VerticalFlick
                width: 60 * fontMetrics.averageCharacterWidth
                Layout.fillHeight: true

                TextArea.flickable: TextArea {
                    id: logTextArea

                    leftPadding: (this.horizontalPadding ?? this.padding ?? 0) + (logScrollBar.mirrored ? logScrollBar.width : 0)
                    rightPadding: (this.horizontalPadding ?? this.padding ?? 0) + (logScrollBar.mirrored ? 0 : logScrollBar.width)
                    font: fixedFont
                    readOnly: true
                    hoverEnabled: false
                    activeFocusOnPress: false
                    wrapMode: TextArea.Wrap
                }

                ScrollBar.vertical: ScrollBar {
                    id: logScrollBar
                }
            }
        }
    }
}
