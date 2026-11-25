
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property string compositor:
        Quickshell.env("NIRI_SOCKET") ? "niri" :
        Quickshell.env("SWAYSOCK") ? "sway" : "unknown"

    property var workspaces: []

    implicitWidth: workspaceRow.implicitWidth
    implicitHeight: 28

    function refresh() {
        if (!workspaceProc.running)
            workspaceProc.running = true
    }

    function activateWorkspace(ws) {
        if (compositor === "niri") {
            focusProc.command = [
                "niri", "msg", "action",
                "focus-workspace", "--reference",
                String(ws.id)
            ]
        } else if (compositor === "sway") {
            focusProc.command = [
                "swaymsg", "workspace",
                "number", String(ws.index)
            ]
        } else {
            return
        }

        focusProc.running = true
    }

    Process {
        id: workspaceProc

        command: root.compositor === "niri"
            ? ["niri", "msg", "--json", "workspaces"]
            : ["swaymsg", "-t", "get_workspaces", "-r"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text)

                    if (root.compositor === "niri") {
                        const screenName = Quickshell.screens[0]?.name

                        root.workspaces = data
                            .filter(ws => ws.output === screenName)
                            .sort((a, b) => a.idx - b.idx)
                            .map(ws => ({
                                id: ws.id,
                                index: ws.idx,
                                name: String(ws.idx),
                                focused: ws.is_focused,
                                active: ws.is_active
                            }))
                    } else {
                        root.workspaces = data.map(ws => ({
                            id: ws.num,
                            index: ws.num,
                            name: ws.name,
                            focused: ws.focused,
                            active: ws.visible
                        }))
                    }
                } catch (error) {
                    console.warn("Workspace parsing failed:", error)
                }
            }
        }
    }

    Process {
        id: focusProc
    }

    Timer {
        interval: 1500
        running: root.compositor !== "unknown"
        repeat: true
        triggeredOnStart: true

        onTriggered: root.refresh()
    }

    Row {
        id: workspaceRow
        spacing: 5

        Repeater {
            model: root.workspaces

            delegate: Rectangle {
                required property var modelData

                width: Math.max(30, workspaceLabel.implicitWidth + 16)
                height: 26
                radius: 4

                color: modelData.focused
                    ? "#d79921"
                    : modelData.active
                        ? "#504945"
                        : "#3c3836"

                Text {
                    id: workspaceLabel

                    anchors.centerIn: parent
                    text: modelData.name

                    color: modelData.focused
                        ? "#282828"
                        : "#ebdbb2"

                    font.pixelSize: 12
                    font.bold: modelData.focused
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: root.activateWorkspace(modelData)
                }
            }
        }
    }
}

