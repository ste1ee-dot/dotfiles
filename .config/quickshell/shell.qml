import QtQuick
import QtQuick.Layouts
import Quickshell

ShellRoot {
    id: root

    property real barWidth: 40

    Notifications {
        barWidth: root.barWidth
    }


    PanelWindow {
        id: panel
        anchors {
            top: true
            bottom: true
            right: true
        }
        implicitWidth: root.barWidth
        color: Theme.bg2


        ColumnLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.topMargin: 14
            anchors.bottomMargin: 14

            Workspaces {
                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
            }

            ColumnLayout {
                id: bottomLayout
                Layout.fillWidth: true
                spacing: 12

                Network {
                    Layout.fillWidth: true
                }
                Volume {
                    Layout.fillWidth: true
                    bar: panel;
                }
                Battery {
                    Layout.fillWidth: true
                }
                Clock {
                    Layout.fillWidth: true
                }
            }
        }
    }
}
