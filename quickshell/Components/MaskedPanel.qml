import Quickshell
import QtQuick

PanelWindow {
    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }
    color: "transparent"

    mask: Region {
        Region {
            x: rect.x
            y: rect.y
            width: rect.width
            height: rect.height
        }
    }
}
