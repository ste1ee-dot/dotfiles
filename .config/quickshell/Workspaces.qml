import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Item {
    id: rootItem
    implicitHeight: root.implicitHeight

    ColumnLayout {
        id: root
        spacing: 4
        width: parent.width

        Repeater {
            model: 5

            Rectangle {
                id: wsButton
                required property int index

                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                implicitWidth: label.implicitWidth + 13
                implicitHeight: 22
                radius: 6
                color: isActive ? Theme.bg5 : (ws ? Theme.bg3 : "transparent")
                Layout.alignment: Qt.AlignHCenter

                Behavior {
                    ColorAnimation {
                        duration: 150
                    }
                }

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: wsButton.index + 1
                    color: wsButton.isActive ? Theme.fg : (wsButton.ws ? Theme.fg2 : Theme.fg4)

                    font {
                        family: "SF Pro Display"
                        pixelSize: 14
                        weight: 500
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.index + 1) + "})")
                }
            }
        }
    }
}
