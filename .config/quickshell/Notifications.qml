import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    required property real barWidth

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            console.log("got:", n.summary, "---", n.body);
            n.tracked = true;
        }
    }

    PanelWindow {
        anchors {
            top: true
            right: true
        }
        margins {
            top: 10
            right: root.barWidth + 10
        }
        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 4

            Repeater {
                model: server.trackedNotifications
                Rectangle {
                    id: card
                    required property var modelData

                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        interval: 5000
                        onTriggered: card.modelData.dismiss()
                    }

                    Layout.fillWidth: true
                    //Layout.preferredHeight: Math.max(60, layout.implicitHeight + 16)
                    Layout.preferredHeight: Math.max(60, Math.max(icon.visible ? 36 : 0, textColumn.implicitHeight) + 16)
                    radius: 6
                    color: Theme.bg2
                    border.width: 2
                    border.color: Theme.border

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        Image {
                            id: icon
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() != ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            id: textColumn

                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            Layout.minimumWidth: 0
                            spacing: 4

                            Text {
                                Layout.fillWidth: true
                                Layout.minimumWidth: 0

                                text: card.modelData.summary
                                color: Theme.fg

                                font {
                                    family: "SF Pro Display"
                                    pixelSize: 14
                                    weight: 700
                                }

                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                Layout.minimumWidth: 0

                                text: card.modelData.body
                                visible: text !== ""
                                color: Theme.fg

                                font {
                                    family: "SF Pro Display"
                                    pixelSize: 12
                                    weight: 500
                                }

                                wrapMode: Text.Wrap
                                onWidthChanged: {
                                    console.log("body width:", width, "textColumn:", textColumn.width, "row:", layout.width, "card:", card.width);
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: card.modelData.dismiss()
                    }
                }
            }
        }
    }
}
