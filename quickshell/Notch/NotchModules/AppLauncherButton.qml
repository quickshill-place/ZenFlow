import qs.Settings
import Quickshell
import QtQuick
import qs.Components
import qs.Components.Icons

IconButton {
    icon: "\ufaab"
    onClicked: {
        Settings.settings.enableAppLauncher = !Settings.settings.enableAppLauncher;
    }
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: Settings.settings.globalMargin
}
