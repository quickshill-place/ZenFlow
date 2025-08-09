import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Settings

Rectangle {
    radius: parent.height / 10
    width: 100
    height: 100
    color: Settings.settings.isDark ? Theme.backgroundPrimary : Theme.textPrimary
}
