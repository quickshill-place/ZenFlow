import qs.Settings
import Quickshell
import QtQuick
import qs.Components

IconButton {
    icon: "\ufaab"
    onClicked: {
        Settings.settings.enableAppLauncher = !Settings.settings.enableAppLauncher;
    }
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: Settings.settings.globalMargin
}
