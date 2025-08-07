import Quickshell
import QtQuick
import qs.Widgets.styles
import qs.Components

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }

    mask: Region {
        Region {
            x: menu.x
            y: menu.y
            width: menu.width
            height: menu.height
        }
    }

    color: "transparent"

    StyledRect {
        id: menu
        radius: 50
        // anchors.centerIn: parent
        width: parent.width / 2
        height: parent.height / 2

        StyledRect {

            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.horizontalCenter: parent.horizontalCenter
            Tabs {
                id: settingsTabs
                tabsModel: [
                    {
                        icon: "\uf69e"
                    },
                    {
                        icon: "\ufb27"
                    },
                    {
                        icon: "\uf673"
                    }
                ]
            }
        }
    }
}
