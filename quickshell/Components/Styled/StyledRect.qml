import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Settings

Rectangle {
    radius: Settings.settings.hasRadius ? height / 2 : 0
    width: 100
    height: 100
    color: Settings.settings.darkMode ? Theme.backgroundPrimary : Theme.textPrimary
}
