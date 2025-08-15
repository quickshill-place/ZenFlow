import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Settings
import qs.Services

Variants {
    model: Quickshell.screens

    delegate: Component {
        PanelWindow {
            id: root
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Background
            required property var modelData

            // we can then set the window's screen to the injected property
            screen: modelData
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
    }
}
