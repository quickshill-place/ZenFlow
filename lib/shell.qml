import Quickshell
import QtQuick

ShellRoot {

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
