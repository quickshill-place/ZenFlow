pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

Singleton {

    property string shellName: "ZenFlow"
    property string settingsDir: Quickshell.env("HOME") + "/zenflow/quickshell/Settings"
    property string settingsFile: Quickshell.env("HOME") + "/.config/Settings.json"
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
            property string weatherCity: ""
            property string currentWallpaper: Paths.home + "/Wallpapers/anime-girl-ballons.png"
            property string wallpaperResize: "crop"
            property string transitionType: "random"
            property string visualizerType: "radial"
            property int wallpaperInterval: 300
            property int taskbarIconSize: 24
            property int transitionFps: 90
            property bool useFahrenheit: false
            property bool showActiveWindowIcon: false
            property bool showSystemInfoInBar: false
            property bool showCorners: true
            property bool showTaskbar: true
            property bool showMediaInBar: false
            property bool randomWallpaper: false
            property bool useWallpaperTheme: false
            property bool reverseDayMonth: false
            property bool use12HourClock: false
            property bool dimPanels: true
            property real fontSizeMultiplier: 1.0
            property real transitionDuration: 1.1
            property var pinnedExecs: []
        }
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
