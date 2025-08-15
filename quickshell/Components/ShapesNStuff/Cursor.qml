import QtQuick
import Quickshell
import qs.Settings

PanelWindow {
    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    mask: Region {
        item: moussie
        intersection: Intersection.Intersect
    }
    color: "transparent"
    Item {
        anchors.fill: parent

        StyledRect {
            id: cross
            width: 0.1
            height: 0.1

            color: "transparent"

            TextIcon {
                anchors.centerIn: parent
                text: "\ueb0b"
                color: Settings.settings.isDark ? Theme.textPrimary : Theme.backgroundPrimary
            }
        }
        MouseArea {
            id: moussie
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged: {
                cross.x = mouseX;
                cross.y = mouseY;
            }
        }
    }
}
