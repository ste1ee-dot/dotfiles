import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

Item {
    id: rootItem
    implicitHeight: root.implicitHeight

    ColumnLayout {
        id: root
        spacing: 2
        width: parent.width

        property var battery: UPower.displayDevice
        property var charging: battery.state === UPowerDeviceState.Charging
        readonly property int level: Math.round(battery.percentage * 100)

        readonly property string icon: {
            if (charging)
                return String.fromCodePoint(0xF0084);
            if (level >= 100)
                return String.fromCodePoint(0xF0079);
            if (level < 10)
                return String.fromCodePoint(0xF0083);

            return String.fromCodePoint(0xF007A + (Math.floor(level / 10) - 1));
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
                color: root.charging ? Theme.green : root.level <= 15 ? Theme.red : root.level <= 30 ? Theme.orange : Theme.fg
                font {
                    family: "JetBrainsMono Nerd Font Propo"
                    pixelSize: 14
                }
            }

            //MouseArea {
            //    anchors.fill: parent
            //    cursorShape: Qt.PointingHandCursor
            //    hoverEnabled: true

            //    onClicked: {
            //        root.sink.audio.muted = !root.sink.audio.muted;
            //    }
            //}
        }

        //Text {
        //    text: root.level + "%"
        //    color: Theme.fg
        //    font {
        //        family: "SF Pro Display"
        //        pixelSize: 12
        //        weight: 500
        //    }
        //    Layout.alignment: Qt.AlignHCenter
        //}
    }
}
