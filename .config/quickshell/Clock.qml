import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: rootItem
    implicitHeight: timeText.implicitHeight

    Text {
        id: timeText
        anchors.horizontalCenter: parent.horizontalCenter

        text: Qt.formatDateTime(clock.date, "hh\nmm")
        color: Theme.fg1

        font {
            family: "SF Mono"
            letterSpacing: -1
            pixelSize: 16
            weight: 700
        }

        SystemClock {
            id: clock

            precision: SystemClock.Minutes
        }
    }
}
