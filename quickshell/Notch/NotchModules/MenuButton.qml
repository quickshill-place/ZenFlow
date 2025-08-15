import qs.Settings
import qs.Components
import Quickshell.Io
import Quickshell
import QtQuick

IconButton {
    icon: Settings.settings.enableMenu ? "\ufc3e" : "\ufc3c"
    onClicked: Settings.settings.enableMenu = !Settings.settings.enableMenu
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: Settings.settings.globalMargin
}
