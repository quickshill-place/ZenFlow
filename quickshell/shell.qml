import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import qs.Widgets.audio
import qs.Widgets.border
import qs.Apps.applaunch
import qs.Notch

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
