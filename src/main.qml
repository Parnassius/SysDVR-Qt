import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ApplicationWindow {
    visible: true
    minimumWidth: mainPane.width
    maximumWidth: mainPane.width
    minimumHeight: mainPane.height
    maximumHeight: mainPane.height
    title: "SysDVR-Qt"

    onClosing: sysdvr.cleanup()

    Settings {
        id: settings

        property string channel: "both"
        property string source: "usb"
        property alias ipAddress: ipAddress.text
        property alias useCustomTitle: useCustomTitle.checked
        property alias customTitle: customTitle.text
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
        function onStateChanged(running) {
            mainSection.enabled = !running;
        }

        target: sysdvr
    }

    Pane {
        id: mainPane

        ColumnLayout {
            anchors.fill: parent

            ColumnLayout {
                id: mainSection

                Label {
                    text: qsTr("Channels to stream")
                }
                ButtonGroup {
                    id: channels
                    checkedButton: settings.getCheckedButton(this, settings.channel)
                    onClicked: (button) => settings.channel = button.objectName
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

                Kirigami.Separator {
                    Layout.fillWidth: true
                }

                Label {
                    text: qsTr("Stream source")
                }
                ButtonGroup {
                    id: source
                    checkedButton: settings.getCheckedButton(this, settings.source)
                    onClicked: (button) => settings.source = button.objectName
                }
                RadioButton {
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
                    placeholderText: qsTr("IP address (optional)")
                    enabled: sourceTCPBridge.checked
                    Layout.fillWidth: true
                }

                Kirigami.Separator {
                    Layout.fillWidth: true
                }

                CheckBox {
                    id: useCustomTitle
                    text: qsTr("Use custom window title")
                }
                TextField {
                    id: customTitle
                    placeholderText: qsTr("Custom window title")
                    enabled: useCustomTitle.checked
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
                icon.name: "dialog-cancel-symbolic"
                visible: !mainSection.enabled
                Layout.fillWidth: true
                onClicked: sysdvr.terminate()
            }
            Button {
                text: qsTr("Start")
                icon.name: "media-playback-start-symbolic"
                visible: mainSection.enabled
                Layout.fillWidth: true
                onClicked: sysdvr.start()
            }
        }
    }
}
