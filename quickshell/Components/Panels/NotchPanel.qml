import Quickshell
import QtQuick
import Quickshell.Wayland
import qs.Settings

PanelWindow {
    id: outerPanel

    property bool showOverlay: Settings.settings.dimPanels
    property int topMargin: 36
    property color overlayColor: showOverlay ? Theme.overlay : "transparent"

    function dismiss() {
        visible = false;
    }

    function show() {
        visible = true;
    }

    implicitWidth: screen.width
    implicitHeight: screen.height
    color: "transparent"
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    screen: (typeof modelData !== 'undefined' ? modelData : null)
    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true

    MouseArea {
        anchors.fill: parent
        onClicked: Settings.settings.expandContent = false
    }

    Behavior on color {
        ColorAnimation {
            duration: 350
            easing.type: Easing.InOutCubic
        }
    }
}
