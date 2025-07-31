import QtQuick
import Quickshell
import "root:/colors.js" as Colors

PanelWindow {
    exclusionMode: ExclusionMode.Ignore
    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }
    color: Colors.blue

    aboveWindows: false
}
