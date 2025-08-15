import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Window
import QtQuick.Layouts

import qs.Widgets.audio
import qs.Widgets.border
import qs.Apps.applaunch
import qs.Menu
import qs.Notch
import qs.Modules
import qs.Wallpaper
import qs.Components
import qs.Settings

ShellRoot {

    Kanban {}

    Connections {
        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }

        function onReloadFailed() {
            Quickshell.inhibitReloadPopup();
        }

        target: Quickshell
    }

    // Force initialization of some singletons
    /* Component.onCompleted: {
        Cliphist.refresh();
        FirstRunExperience.load();
        Hyprsunset.load();
        MaterialThemeLoader.reapplyTheme();
    }*/

    LazyLoader {
        active: Settings.settings.enableNotch

        component: NotchV2 {}
    }
    LazyLoader {
        active: Settings.settings.enableBackground

        component: Wallpaper {}
    }
    LazyLoader {
        active: Settings.settings.enableAppLauncher
        component: Applauncher {}
    }
    LazyLoader {
        active: Settings.settings.enableMenu
        component: Menu {}
    }
    LazyLoader {
        active: Settings.settings.enableBackgroundSwitcher
        component: WallpaperPanel {}
    }
}
