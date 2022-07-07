import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.0

ApplicationWindow {
    visible: true
    minimumWidth: mainPane.width
    maximumWidth: mainPane.width
    minimumHeight: mainPane.height
    maximumHeight: mainPane.height

    title: "SysDVR-Qt"

    Settings {
        id: settings
        property string channel: "channelsBoth"
        property string source: "sourceUSB"
        property alias ipAddress: ipAddress.text
    }

    Connections {
        target: sysdvr
        function onMessage(msg) {
            logTextArea.append(msg)
        }
        function onStateChanged(running) {
            mainSection.enabled = !running
            if (running) {
                logTextArea.clear()
            }
        }
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
                        onClicked: settings.channel = button.objectName
                    }
                    RadioButton {
                        objectName: "channelsVideo"
                        text: qsTr("Video only")
                        checked: settings.channel === this.objectName
                        ButtonGroup.group: channels
                    }
                    RadioButton {
                        objectName: "channelsAudio"
                        text: qsTr("Audio only")
                        checked: settings.channel === this.objectName
                        ButtonGroup.group: channels
                    }
                    RadioButton {
                        objectName: "channelsBoth"
                        text: qsTr("Both video and audio")
                        checked: settings.channel === this.objectName
                        ButtonGroup.group: channels
                    }

                    Label {
                        text: qsTr("Stream source")
                    }
                    ButtonGroup {
                        id: source
                        onClicked: settings.source = button.objectName
                    }
                    RadioButton {
                        id: sourceUSB
                        objectName: "sourceUSB"
                        text: qsTr("USB")
                        checked: settings.source === this.objectName
                        ButtonGroup.group: source
                    }
                    RadioButton {
                        id: sourceTCPBridge
                        objectName: "sourceTCPBridge"
                        text: qsTr("TCP Bridge")
                        checked: settings.source === this.objectName
                        ButtonGroup.group: source
                    }
                    TextField {
                        id: ipAddress
                        objectName: "ipAddress"
                        placeholderText: qsTr("IP address")
                        enabled: sourceTCPBridge.checked
                        Layout.fillWidth: true
                    }
                }

                Button {
                    text: qsTr("Terminate")
                    visible: !mainSection.enabled
                    Layout.fillWidth: true

                    onClicked: {
                        sysdvr.terminate()
                    }
                }
                Button {
                    text: qsTr("Start")
                    visible: mainSection.enabled
                    enabled: sourceUSB.checked || ipAddress.text
                    Layout.fillWidth: true

                    onClicked: {
                        sysdvr.start(
                            settings.channel, settings.source, settings.ipAddress
                        )
                    }
                }
            }

            Flickable {
                clip: true
                boundsBehavior: Flickable.DragOverBounds
                width: 60 * fontMetrics.averageCharacterWidth
                Layout.fillHeight: true
                TextArea.flickable: TextArea {
                    id: logTextArea
                    font: fixedFont
                    readOnly: true
                    hoverEnabled: false
                    activeFocusOnPress: false
                    wrapMode: TextArea.Wrap
                }
                ScrollBar.vertical: ScrollBar { }
            }
        }
    }
}
