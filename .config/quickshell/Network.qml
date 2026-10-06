import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts

Item {
    id: rootItem
    implicitHeight: root.implicitHeight

    ColumnLayout {
        id: root
        spacing: 6
        width: parent.width

        property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
        property var active: wifiDevice ? wifiDevice.networks.values.find(n => n.connected) : null

        readonly property real signal: active ? active.signalStrength : 0

        readonly property string icon: {
            if (!Networking.wifiEnabled)
                return String.fromCodePoint(0xF05AA);
            if (!active)
                return String.fromCodePoint(0xF092D);

            let tier = signal >= 0.75 ? 4 : signal >= 0.50 ? 3 : signal >= 0.25 ? 2 : 1;

            return String.fromCodePoint(0xF091F + (tier - 1) * 3);
        }
        Rectangle {
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
                color: Networking.wifiEnabled ? Theme.fg : Theme.fg4
                font {
                    family: "JetBrainsMono Nerd Font Propo"
                    pixelSize: 14
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onClicked: {
                    Networking.wifiEnabled = !Networking.wifiEnabled;
                }
            }
        }

        //Text {
        //    text: {
        //        if (!Networking.wifiEnabled)
        //            return "off";
        //        if (!root.active)
        //            return "Disconnected";

        //        return root.active.name;
        //    }

        //    color: Theme.fg
        //    font {
        //        family: "SF Pro Display"
        //        pixelSize: 13
        //        weight: 500
        //    }
        //    Layout.alignment: Qt.AlignHCenter
        //}
    }
}
