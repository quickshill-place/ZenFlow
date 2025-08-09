import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Settings

Rectangle {
    radius: Settings.settings.hasRadius ? 50 : 0
    width: 100
    height: 100
    color: Settings.settings.isDark ? Theme.backgroundPrimary : Theme.textPrimary
}
