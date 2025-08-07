import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Settings
import qs.Services

PanelWindow {
    id: root
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Background

    CachingImages {
        id: img
        path: WallpaperManager.currentWallpaper

        width: parent.width
        height: parent.height
    }

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }
    color: "transparent"

    aboveWindows: false
}
