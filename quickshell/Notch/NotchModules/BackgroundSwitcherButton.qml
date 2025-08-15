import qs.Settings
import qs.Components
import Quickshell.Io
import Quickshell
import QtQuick

IconButton {
    icon: Settings.settings.enableBackgroundSwitcher ? "\ufb2e" : "\uf1f6"
    onClicked: Settings.settings.enableBackgroundSwitcher = !Settings.settings.enableBackgroundSwitcher
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: Settings.settings.globalMargin
}
