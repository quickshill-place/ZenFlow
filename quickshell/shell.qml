import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import "colors.js" as Colors
import qs.widgets.audio
import qs.widgets.border
import qs.apps.applaunch
import qs.bar
import qs.notch

Scope {

    Audio {}

    Notch {}

    Connections {
        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }

        function onReloadFailed() {
            Quickshell.inhibitReloadPopup();
        }

        target: Quickshell
    }
}
