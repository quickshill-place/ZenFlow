import qs.Settings
import qs.Components
import Quickshell.Io
import Quickshell
import QtQuick

IconButton {
    icon: "\ufb27"
    onClicked: {
        procie.running = true;
    }
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: Settings.settings.globalMargin
    Process {
        id: procie
        running: false
        command: ["gnome-calendar"]
    }
}
