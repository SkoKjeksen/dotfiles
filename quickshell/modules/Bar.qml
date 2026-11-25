import QtQuick
import Quickshell
import "."

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 36
    color: "#282828"

    Workspaces {
        anchors {
            left: parent.left
            leftMargin: 12
            verticalCenter: parent.verticalCenter
        }
    }

    Text {
        id: clock

        anchors {
            right: parent.right
            rightMargin: 14
            verticalCenter: parent.verticalCenter
        }

        property var currentTime: new Date()

        text: Qt.formatDateTime(currentTime, "ddd dd.MM  HH:mm")
        color: "#ebdbb2"
        font.pixelSize: 13

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.currentTime = new Date()
        }
    }
}

