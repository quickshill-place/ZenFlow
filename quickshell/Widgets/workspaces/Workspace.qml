import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import qs.Widgets.styles
import qs.Settings

Item {
    id: workie
    readonly property string appTitle: ToplevelManager.activeToplevel.title
    property bool shouldShow: false
    property bool finallyHidden: false

    Timer {
        id: visibilityTimer
        interval: 1200
        running: false
        onTriggered: {
            workie.shouldShow = false;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 300
        running: false
        onTriggered: workie.finallyHidden = true
    }
    anchors.centerIn: parent
    function getIcon() {
        var icon = Quickshell.iconPath(ToplevelManager.activeToplevel.appId.toLowerCase(), true);
        if (!icon) {
            icon = Quickshell.iconPath(ToplevelManager.activeToplevel.appId, true);
        }
        if (!icon) {
            icon = Quickshell.iconPath(ToplevelManager.activeToplevel.title, true);
        }
        if (!icon) {
            icon = Quickshell.iconPath(ToplevelManager.activeToplevel.title.toLowerCase(), "application-x-executable");
        }

        return icon;
    }
    Connections {
        target: ToplevelManager
        function onActiveToplevelChanged() {
            if (ToplevelManager.activeToplevel?.appId) {
                workie.shouldShow = true;
                workie.finallyHidden = false;
                visibilityTimer.restart();
            } else {
                workie.shouldShow = false;
                hideTimer.restart();
                visibilityTimer.stop();
            }
        }
    }
    IconImage {
        id: icon
        width: 12
        height: 12
        anchors.left: parent.left
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        source: ToplevelManager?.activeToplevel ? getIcon() : ""
        visible: Settings.settings.showActiveWindowIcon
        anchors.verticalCenterOffset: -3
    }

    StyledText {
        text: ToplevelManager?.activeToplevel?.title && ToplevelManager?.activeToplevel?.title.length > 30 ? ToplevelManager?.activeToplevel?.title.substring(0, 10) + "..." : ToplevelManager?.activeToplevel?.title || ""
        rotation: 270
        anchors.centerIn: parent
    }
}
