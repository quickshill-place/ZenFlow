pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

Singleton {
    property string shellName: "ZenFlow"
    property string settingsDir: Quickshell.env("HOME") + "/zenflow/quickshell/Settings"
    property string settingsFile: Quickshell.env("HOME") + "/zenflow/quickshell/Settings.json"
    property string themeFile: Quickshell.env("HOME") + "/zenflow/quickshell/Settings/Theme.json"
    property var settings: settingAdapter

    FileView {
        id: settingFileView
        path: settingsFile
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        Component.onCompleted: function () {
            reload();
        }
        onLoaded: function () {
            Qt.callLater(function () {
                WallpaperManager.setCurrentWallpaper(settings.currentWallpaper, true);
            });
        }
        onLoadFailed: function (error) {
            writeAdapter();
        }
        JsonAdapter {
            id: settingAdapter
            property string videoPath: Quickshell.env("HOME") + "/Videos"
            property string profileImage: Quickshell.env("HOME") + "/.face"
            property string wallpaperFolder: Quickshell.env("HOME") + "/Wallpapers"
            property string weatherCity: "Rome"
            property string currentWallpaper: ""
            property string wallpaperResize: "crop"
            property string transitionType: "random"
            property string visualizerType: "radial"
            property int wallpaperInterval: 300
            property int animationDuration: 300
            property int taskbarIconSize: 24
            property bool useFahrenheit: false
            property bool enableNotch: false
            property bool enableMenu: false
            property bool enableBackground: true
            property bool enableBackgroundSwitcher: false
            property bool enableAppLauncher: false
            property bool enableCheatsheet: false
            property bool expandContent: false
            property bool useWallpaperTheme: false
            property bool reverseDayMonth: false
            property bool use12HourClock: false
            property bool dimPanels: true
            property bool darkMode: true
            property bool hasRadius: true
            property real fontSizeMultiplier: 1.0
            property real transitionDuration: 1.1
            property real globalMargin: 16
            property var pinnedExecs: []
        }
    }
    enum Direction {
        Top,
        Bottom,
        Right,
        Left
    }

    Connections {
        target: settingAdapter
        function onRandomWallpaperChanged() {
            WallpaperManager.toggleRandomWallpaper();
        }
        function onWallpaperIntervalChanged() {
            WallpaperManager.restartRandomWallpaperTimer();
        }
        function onWallpaperFolderChanged() {
            WallpaperManager.loadWallpapers();
        }
    }
}
