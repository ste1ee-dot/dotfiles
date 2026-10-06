import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

Item {
    id: rootItem
    implicitHeight: root.implicitHeight

    property var bar

    ColumnLayout {
        id: root
        spacing: 2
        width: parent.width

        property var sink: Pipewire.defaultAudioSink

        readonly property bool ready: sink && sink.ready
        readonly property bool muted: ready && sink.audio.muted
        readonly property int vol: ready ? Math.round(sink.audio.volume * 100) : 0

        property bool initialized: false

        onVolChanged: {
            if (!ready)
                return;

            if (!initialized) {
                initialized = true;
                return;
            }

            popup.open();
            popupTimer.restart();
        }

        readonly property string icon: {
            if (!ready)
                return String.fromCodePoint(0xF0581);
            if (muted)
                return "󰸈";

            if (vol === 0)
                return String.fromCodePoint(0xF0581);
            if (vol < 34)
                return String.fromCodePoint(0xF057F);
            if (vol < 67)
                return String.fromCodePoint(0xF0580);

            return String.fromCodePoint(0xF057E);
        }

        MouseArea {
            anchors.fill: parent
            height: root.height
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    root.sink.audio.muted = !root.sink.audio.muted;
                    return;
                }

                if (mouse.button === Qt.LeftButton) {
                    if (popup.opened) {
                        popupTimer.stop();
                        popup.close();
                    } else {
                        popup.open();
                        popupTimer.restart();
                    }
                }
            }
            onWheel: wheel => {
                if (!root.ready)
                    return;

                if (wheel.angleDelta.y > 0)
                    root.sink.audio.volume = Math.min(root.sink.audio.volume + 0.05, 1.5);
                else if (wheel.angleDelta.y < 0)
                    root.sink.audio.volume = Math.max(root.sink.audio.volume - 0.05, 0.0);
            }
        }
        Rectangle {
            id: toplevel
            implicitWidth: 22
            implicitHeight: 22
            radius: 6
            color: Theme.bg3
            Layout.alignment: Qt.AlignHCenter

            Behavior {
                ColorAnimation {
                    duration: 150
                }
            }

            Text {
                id: label
                anchors.centerIn: parent
                text: root.icon
                color: Theme.fg
                font {
                    family: "JetBrainsMono Nerd Font Propo"
                    pixelSize: 14
                }
            }

            PopupWindow {
                id: popup

                property bool opened: false
                property real popupWidth: 200

                anchor {
                    item: root
                    edges: Edges.Left
                    gravity: Edges.Left
                    margins.left: 0
                    adjustment: PopupAdjustment.None
                }

                implicitWidth: popupWidth
                implicitHeight: root.height

                color: "transparent"
                visible: opened || popupContent.width > 0

                function toggle() {
                    if (opened)
                        close();
                    else
                        open();
                }

                function open() {
                    visible = true;
                    opened = true;
                }

                function close() {
                    opened = false;
                }

                Rectangle {
                    id: popupContent

                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        right: parent.right
                    }

                    width: popup.opened ? popup.popupWidth : 0

                    topRightRadius: 0
                    bottomRightRadius: 0
                    topLeftRadius: 6
                    bottomLeftRadius: 6

                    color: Theme.bg2
                    clip: true

                    Behavior on width {
                        NumberAnimation {
                            duration: 220
                            easing.type: Easing.OutCubic
                        }
                    }

                    Item {
                        anchors {
                            fill: parent
                            leftMargin: 12
                            rightMargin: 12
                        }

                        opacity: popup.opened ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 120
                            }
                        }

                        Rectangle {
                            id: sliderTrack

                            anchors.centerIn: parent

                            width: parent.width
                            height: 4
                            radius: 2

                            color: Theme.bg4

                            Rectangle {
                                id: sliderFill

                                anchors {
                                    left: parent.left
                                    top: parent.top
                                    bottom: parent.bottom
                                }

                                width: parent.width * Math.min(root.vol / 150, 1)
                                radius: parent.radius

                                color: Theme.fg
                            }
                        }

                        Rectangle {
                            id: sliderHandle

                            width: 12
                            height: 12
                            radius: 6

                            anchors.verticalCenter: parent.verticalCenter

                            x: (parent.width - width) * Math.min(root.vol / 150, 1)

                            color: Theme.fg
                        }

                        MouseArea {
                            anchors.fill: parent

                            function setVolume(mouseX) {
                                if (!root.ready)
                                    return;
                                const position = Math.max(0, Math.min(mouseX / width, 1));

                                root.sink.audio.volume = position * 1.5;
                            }

                            onPressed: mouse => {
                                setVolume(mouse.x);
                            }

                            onPositionChanged: mouse => {
                                if (pressed)
                                    setVolume(mouse.x);
                            }
                        }
                    }
                }
            }
            Timer {
                id: popupTimer
                interval: 1500
                repeat: false

                onTriggered: {
                    popup.close();
                }
            }
        }

        Text {
            text: {
                if (!root.ready)
                    return "-";
                if (root.muted)
                    return "Muted";

                return root.vol + "%";
            }
            color: root.muted ? Theme.red : Theme.fg

            font {
                family: "SF Pro Display"
                pixelSize: 12
                weight: 500
            }
            Layout.alignment: Qt.AlignHCenter
            visible: popup.opened ? true : false
        }

        PwObjectTracker {
            objects: [root.sink]
        }
    }
}
